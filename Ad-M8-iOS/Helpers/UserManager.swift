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

        let newUser = PFUser()
        newUser.firstName = userInfo["firstName"] as! String
        newUser.lastName = userInfo["lastName"] as! String
        newUser.email = userInfo["email"] as? String
        newUser.password = userInfo["password"] as? String
        newUser.username = userInfo["email"] as? String
        newUser.location = userInfo["location"] as! String
        newUser.dateOfBirth = userInfo["dateOfBirth"] as! Date
        newUser.gender = userInfo["gender"] as! String
        newUser.invitationCode = userInfo["invitationCode"] as! Int

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

    func login(withUsername username: String, password: String, completion: @escaping (PFUser?, ErrorMessage?) -> Void) {
        PFUser.logInWithUsername(inBackground: username, password: password) { (user, error) in

            guard let user = user, error == nil else {
                DispatchQueue.main.async {
                    if let error = error {
                        completion(nil, ErrorMessage.parseError(error.localizedDescription))
                    } else {
                        completion(nil, ErrorMessage.unknown)
                    }
                }
                return
            }

            user.pinInBackground(block: { (succeeded, error) in
                DispatchQueue.main.async {
                    if error != nil {
                        completion(nil, ErrorMessage.parseError(error!.localizedDescription))
                    } else {
                        completion(user, nil)
                    }
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
}
