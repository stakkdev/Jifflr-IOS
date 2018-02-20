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

        let userDetails = UserDetails()
        userDetails.firstName = userInfo["firstName"] as! String
        userDetails.lastName = userInfo["lastName"] as! String
        userDetails.dateOfBirth = userInfo["dateOfBirth"] as! Date
        userDetails.gender = userInfo["gender"] as! String
        userDetails.emailVerified = false
        userDetails.location = userInfo["location"] as! Location
        userDetails.geoPoint = userInfo["geoPoint"] as! PFGeoPoint
        userDetails.displayLocation = userInfo["displayLocation"] as! String

        if let invitationCode = userInfo["invitationCode"] as? String {
            userDetails.invitationCode = invitationCode
        }

        let newUser = PFUser()
        newUser.details = userDetails
        newUser.email = userInfo["email"] as! String
        newUser.password = userInfo["password"] as? String
        newUser.username = userInfo["email"] as? String

        let query = PFUser.query()
        query?.whereKey("username", equalTo: newUser.email)
        query?.getFirstObjectInBackground(block: { (user, error) in
            if user != nil, error == nil {
                completion(ErrorMessage.userAlreadyExists)
            } else {
                newUser.signUpInBackground { (succeeded, error) in
                    if succeeded {
                        newUser.pinInBackground(block: { (succeeded, error) in
                            if error != nil {
                                completion(ErrorMessage.parseError(error!.localizedDescription))
                            } else {
                                userDetails.pinInBackground(block: { (success, error) in
                                    if error != nil {
                                        completion(ErrorMessage.parseError(error!.localizedDescription))
                                    } else {
                                        completion(nil)
                                    }
                                })
                            }
                        })
                    } else {
                        if error != nil {
                            completion(ErrorMessage.parseError(error!.localizedDescription))
                        } else {
                            completion(ErrorMessage.unknown)
                        }
                    }
                }
            }
        })
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

            user.details.fetchInBackground(block: { (userDetails, error) in
                guard let userDetails = userDetails, error == nil else {
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
                        userDetails.pinInBackground(block: { (success, error) in
                            if error != nil {
                                completion(nil, ErrorMessage.parseError(error!.localizedDescription))
                            } else {
                                completion(user, nil)
                            }
                        })
                    }
                })
            })
        }
    }

    func syncUser(completion: @escaping (ErrorMessage?) -> Void) {
        if let currentUser = Session.shared.currentUser {
            currentUser.fetchInBackground(block: { (user, error) in

                guard let user = user as? PFUser, error == nil else {
                    if let error = error {
                        completion(ErrorMessage.parseError(error.localizedDescription))
                    } else {
                        completion(ErrorMessage.unknown)
                    }
                    return
                }

                user.details.fetchInBackground(block: { (userDetails, error) in
                    guard let userDetails = userDetails, error == nil else {
                        if let error = error {
                            completion(ErrorMessage.parseError(error.localizedDescription))
                        } else {
                            completion(ErrorMessage.unknown)
                        }
                        return
                    }

                    user.pinInBackground(block: { (succeeded, error) in
                        if error != nil {
                            completion(ErrorMessage.parseError(error!.localizedDescription))
                        } else {
                            userDetails.pinInBackground(block: { (success, error) in
                                if error != nil {
                                    completion(ErrorMessage.parseError(error!.localizedDescription))
                                } else {
                                    completion(nil)
                                }
                            })
                        }
                    })
                })
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
