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

    func fetchInvitationCode(email: String, completion: @escaping (String?) -> Void) {
        guard let minimumDate = Calendar.current.date(byAdding: .hour, value: -48, to: Date()) else {
            completion(nil)
            return
        }

        let query = PendingUser.query()
        query?.whereKey("email", equalTo: email)
        query?.whereKey("createdAt", greaterThanOrEqualTo: minimumDate)
        query?.whereKey("active", equalTo: true)
        query?.findObjectsInBackground(block: { (objects, error) in
            guard let pendingUsers = objects as? [PendingUser], pendingUsers.count == 1 else {
                completion(nil)
                return
            }

            completion(pendingUsers.first!.invitationCode)
        })
    }

    func createPendingUser(withUserInfo userInfo: [AnyHashable: Any], completion: @escaping (PendingUser?, ErrorMessage?) -> Void) {

        guard let currentUser = UserManager.shared.currentUser else { return }

        let pendingUser = PendingUser()
        pendingUser.sender = currentUser
        pendingUser.name = userInfo["name"] as! String
        pendingUser.email = userInfo["email"] as! String
        pendingUser.active = true
        pendingUser.isSignedUp = false

        let query = PendingUser.query()
        query?.whereKey("email", equalTo: pendingUser.email)
        query?.whereKey("sender", equalTo: currentUser)
        query?.getFirstObjectInBackground(block: { (user, error) in
            if user != nil, error == nil {
                completion(nil, ErrorMessage.inviteAlreadySent)
            } else {
                pendingUser.saveInBackground { (succeeded, error) in
                    if succeeded {
                        completion(pendingUser, nil)
                    } else {
                        completion(nil, ErrorMessage.inviteSendFailed)
                    }
                }
            }
        })
    }

    func pinPendingUser(pendingUser: PendingUser, completion: @escaping (ErrorMessage?) -> Void) {
        pendingUser.pinInBackground(withName: MyTeamManager.shared.pinName, block: { (success, error) in
            print("PendingUser Pinned: \(success)")

            if let error = error {
                print("Error: \(error)")
                completion(ErrorMessage.unknown)
                return
            }

            completion(nil)
        })
    }

    func deletePendingUser(pendingUser: PendingUser) {
        pendingUser.deleteInBackground { (success, error) in
            print("PendingUser Deleted: \(success)")

            if let error = error {
                print("Error: \(error)")
            }
        }
    }
}
