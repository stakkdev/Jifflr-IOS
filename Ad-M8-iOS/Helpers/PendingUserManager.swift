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

    func createPendingUser(withUserInfo userInfo: [AnyHashable: Any], completion: @escaping (ErrorMessage?) -> Void) {

        guard let currentUser = UserManager.shared.currentUser else {
            completion(ErrorMessage.unknown)
            return
        }

        let newUser = PendingUser()
        newUser.sender = currentUser
        newUser.name = userInfo["name"] as! String
        newUser.email = userInfo["email"] as! String
        newUser.invitationCode = currentUser.invitationCode

        let query = PendingUser.query()
        query?.whereKey("email", equalTo: newUser.email)
        query?.whereKey("invitationCode", equalTo: newUser.invitationCode)
        query?.getFirstObjectInBackground(block: { (user, error) in
            if user != nil, error == nil {
                DispatchQueue.main.async {
                    completion(ErrorMessage.inviteAlreadySent)
                }
            } else {
                newUser.saveInBackground { (succeeded, error) in
                    if succeeded {
                        DispatchQueue.main.async {
                            if error != nil {
                                completion(ErrorMessage.parseError(error!.localizedDescription))
                            } else {
                                completion(nil)
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            if error != nil {
                                completion(ErrorMessage.parseError(error!.localizedDescription))
                            } else {
                                completion(ErrorMessage.unknown)
                            }
                        }
                    }
                }
            }
        })
    }

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
