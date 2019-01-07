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
                    completion(ErrorMessage.cashoutFailed)
                    return
                }
            } else {
                if let _ = error {
                    completion(ErrorMessage.cashoutFailed)
                } else {
                    completion(ErrorMessage.cashoutFailed)
                }
            }
        }
    }
}
