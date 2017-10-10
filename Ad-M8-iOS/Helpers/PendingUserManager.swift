//
//  PendingUserManager.swift
//  Ad-M8-iOS
//
//  Created by James Shaw on 10/10/2017.
//  Copyright © 2017 The Distance. All rights reserved.
//

import UIKit
import Parse

class PendingUserManager: NSObject {
    static let shared = PendingUserManager()

    func fetchPendingUsers(completion: @escaping ([PendingUser], ErrorMessage?) -> Void) {

        guard let currentUser = UserManager.shared.currentUser else {
            completion([], ErrorMessage.pendingUsersFailed)
            return
        }

        let query = PendingUser.query()
        query?.whereKey("invitationCode", equalTo: currentUser.invitationCode)
        query?.findObjectsInBackground(block: { (objects, error) in
            guard let pendingUsers = objects as? [PendingUser] else {
                completion([], ErrorMessage.pendingUsersFailed)
                return
            }

            completion(pendingUsers, nil)
        })
    }
}
