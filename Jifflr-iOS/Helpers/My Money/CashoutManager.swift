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

    func fetchCashouts(user: PFUser, completion: @escaping ([UserCashout], ErrorMessage?) -> Void) {
        let query = UserCashout.query()
        query?.whereKey("user", equalTo: user)
        query?.order(byDescending: "createdAt")
        query?.findObjectsInBackground(block: { (userCashouts, error) in
            guard let userCashouts = userCashouts as? [UserCashout], error == nil else {
                completion([], ErrorMessage.cashoutFetchFailed)
                return
            }

            completion(userCashouts, nil)
        })
    }
}
