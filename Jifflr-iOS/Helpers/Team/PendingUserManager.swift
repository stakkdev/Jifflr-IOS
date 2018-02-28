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

//
//    func fetchPendingUsers(completion: @escaping ([PendingUser], ErrorMessage?) -> Void) {
//
//        guard let currentUser = UserManager.shared.currentUser else {
//            completion([], ErrorMessage.pendingUsersFailed)
//            return
//        }
//
//        let query = PendingUser.query()
//        query?.whereKey("invitationCode", equalTo: currentUser.invitationCode!)
//        query?.order(byDescending: "createdAt")
//        query?.findObjectsInBackground(block: { (objects, error) in
//            guard let pendingUsers = objects as? [PendingUser] else {
//                completion([], ErrorMessage.pendingUsersFailed)
//                return
//            }
//
//            completion(pendingUsers, nil)
//        })
//    }
//
//
//    func fetchSenderAndPendingUser(invitationCode: Int, email: String, completion: @escaping (PFUser?, PendingUser?, ErrorMessage?) -> Void) {
//
//        let query = PendingUser.query()
//        query?.whereKey("invitationCode", equalTo: invitationCode)
//        query?.findObjectsInBackground(block: { (objects, error) in
//            guard let pendingUsers = objects as? [PendingUser], pendingUsers.count > 0, error == nil else {
//                completion(nil, nil, ErrorMessage.pendingUsersFailed)
//                return
//            }
//
//            let sender = pendingUsers.first!.sender
//
//            do {
//                try sender.fetchIfNeeded()
//
//                var pendingUser: PendingUser?
//                for user in pendingUsers {
//                    if user.email == email {
//                        pendingUser = user
//                        break
//                    }
//                }
//
//                completion(sender, pendingUser, nil)
//            } catch let error {
//                completion(nil, nil, ErrorMessage.parseError(error.localizedDescription))
//            }
//        })
//    }
//
//    func delete(pendingUser: PendingUser, completion: @escaping (Bool) -> Void) {
//        pendingUser.deleteInBackground { (success, error) in
//            guard success == true, error == nil else {
//                completion(false)
//                return
//            }
//
//            completion(true)
//        }
//    }
}
