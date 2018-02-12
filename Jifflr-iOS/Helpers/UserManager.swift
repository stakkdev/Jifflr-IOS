//
//  UserManager.swift
//  Ad-M8-iOS
//
//  Created by James Shaw on 09/10/2017.
//  Copyright © 2017 The Distance. All rights reserved.
//

import UIKit
import Parse

class UserManager: NSObject {
    static let shared = UserManager()

    var currentUser: PFUser? {
        return PFUser.current()
    }

    func signUp(withUserInfo userInfo: [AnyHashable: Any], completion: @escaping (ErrorMessage?) -> Void) {

        let group = DispatchGroup()

        let newUser = PFUser()
        newUser.firstName = userInfo["firstName"] as! String
        newUser.lastName = userInfo["lastName"] as! String
        newUser.email = userInfo["email"] as? String
        newUser.password = userInfo["password"] as? String
        newUser.username = userInfo["email"] as? String
        newUser.location = userInfo["location"] as! String
        newUser.dateOfBirth = userInfo["dateOfBirth"] as! Date
        newUser.gender = userInfo["gender"] as! String
        newUser.invitationCode = Int(arc4random_uniform(999999) + 1)

        if let invitationCode = userInfo["invitationCode"] as? Int {
            group.enter()
            PendingUserManager.shared.fetchSenderAndPendingUser(invitationCode: invitationCode, email: newUser.email!, completion: { (sender, pendingUser, error) in
                if let sender = sender, error == nil {
                    newUser.friends = [sender]
                }

                group.leave()

                if let pendingUser = pendingUser, error == nil {
                    PendingUserManager.shared.delete(pendingUser: pendingUser, completion: { (success) in
                        print("Pending User Deleted Success: \(success)")
                    })
                }
            })
        } else {
            newUser.friends = []
        }

        group.notify(queue: DispatchQueue.main) {

            let query = PFUser.query()
            query?.whereKey("username", equalTo: newUser.email!)
            query?.getFirstObjectInBackground(block: { (user, error) in
                if user != nil, error == nil {
                    DispatchQueue.main.async {
                        completion(ErrorMessage.userAlreadyExists)
                    }
                } else {
                    newUser.signUpInBackground { (succeeded, error) in
                        if succeeded {
                            newUser.pinInBackground(block: { (succeeded, error) in
                                DispatchQueue.main.async {
                                    if error != nil {
                                        completion(ErrorMessage.parseError(error!.localizedDescription))
                                    } else {
                                        completion(nil)
                                    }
                                }
                            })
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
    }

    func login(withUsername username: String, password: String, completion: @escaping (PFUser?, ErrorMessage?) -> Void) {
        PFUser.logInWithUsername(inBackground: username, password: password) { (user, error) in

            guard let user = user, error == nil else {
                if let error = error {
                    completion(nil, ErrorMessage.parseError(error.localizedDescription))
                } else {
                    completion(nil, ErrorMessage.unknown)
                }
                return
            }

            user.pinInBackground(block: { (succeeded, error) in
                if error != nil {
                    completion(nil, ErrorMessage.parseError(error!.localizedDescription))
                } else {
                    completion(user, nil)
                }
            })
        }
    }

    func logOut(completion: @escaping (ErrorMessage?) -> Void) {
        PFUser.logOutInBackground { error in
            DispatchQueue.main.async {
                if error != nil {
                    completion(ErrorMessage.parseError(error!.localizedDescription))
                } else {
                    completion(nil)
                }
            }
        }
    }

    func resetPassword(email: String, completion: @escaping (ErrorMessage?) -> Void) {
        PFUser.requestPasswordResetForEmail(inBackground: email, block: { (success, error) -> Void in
            if error == nil && success == true {
                completion(nil)
            } else {
                print("Error: \(error?.localizedDescription ?? "")")
                completion(ErrorMessage.resetPasswordFailed)
            }
        })
    }
}
