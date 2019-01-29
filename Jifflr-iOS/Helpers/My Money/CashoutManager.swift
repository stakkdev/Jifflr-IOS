//
//  CashoutManager.swift
//  Ad-M8-iOS
//
//  Created by James Shaw on 13/10/2017.
//  Copyright © 2017 The Distance. All rights reserved.
//

import UIKit
import Parse

class CashoutManager: NSObject {
    static let shared = CashoutManager()

    func cashout(password: String, completion: @escaping (ErrorMessage?) -> Void) {
        guard let user = Session.shared.currentUser else { return }
        
        guard Reachability.isConnectedToNetwork() else {
            completion(ErrorMessage.cashoutFailedInternet)
            return
        }

        PFCloud.callFunction(inBackground: "cash-out", withParameters: ["user": user.objectId!, "password": password]) { responseJSON, error in
            if let success = responseJSON as? Bool, error == nil {
                if success == true {
                    completion(nil)
                    return
                } else {
                    let dict = (error as NSError?)?.userInfo["NSLocalizedDescription"] as? [String: Any]
                    let message = dict?["message"] as? String
                    completion(ErrorMessage.parseError(message ?? ""))
                    return
                }
            } else {
                if let error = error {
                    let dict = (error as NSError?)?.userInfo["NSLocalizedDescription"] as? [String: Any]
                    let message = dict?["message"] as? String
                    completion(ErrorMessage.parseError(message ?? ""))
                } else {
                    completion(ErrorMessage.unknown)
                }
            }
        }
    }
}
