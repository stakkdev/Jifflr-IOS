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
        userDetails.gender = userInfo["gender"] as! Gender
        userDetails.emailVerified = false
        userDetails.location = userInfo["location"] as! Location
        userDetails.geoPoint = userInfo["geoPoint"] as! PFGeoPoint
        userDetails.displayLocation = userInfo["displayLocation"] as! String
        userDetails.pushNotifications = true
        userDetails.moderatorStatus = ModeratorStatusKey.notModerator

        if let invitationCode = userInfo["invitationCode"] as? String {
            userDetails.invitationCode = invitationCode
        }
        
        if let language = userInfo["language"] as? Language {
            userDetails.language = language
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
                            guard error == nil else {
                                completion(ErrorMessage.parseError(error!.localizedDescription))
                                return
                            }

                            userDetails.pinInBackground(block: { (success, error) in
                                guard error == nil else {
                                    completion(ErrorMessage.parseError(error!.localizedDescription))
                                    return
                                }
                                
                                userDetails.gender.pinInBackground(block: { (success, error) in
                                    guard error == nil else {
                                        completion(ErrorMessage.parseError(error!.localizedDescription))
                                        return
                                    }
                                    
                                    userDetails.location.pinInBackground(block: { (success, error) in
                                        guard error == nil else {
                                            completion(ErrorMessage.parseError(error!.localizedDescription))
                                            return
                                        }
                                        
                                        if let invitationCode = userDetails.invitationCode, !invitationCode.isEmpty {
                                            self.registrationInvitation(user: newUser,completion: { (error) in
                                                
                                                if error?.failureDescription == ErrorMessage.invalidInvitationCodeRegistration.failureDescription {
                                                    userDetails.setValue(NSNull(), forKey: "invitationCode")
                                                    userDetails.saveInBackground { (success, error) in
                                                        userDetails.pinInBackground()
                                                    }
                                                    
                                                }
                                                completion(error)
                                                
                                            })
                                        } else {
                                            PFInstallation.registerUser(user: newUser)
                                            completion(nil)
                                        }
                                    })
                                })
                            })
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

    func registrationInvitation(user: PFUser, completion: @escaping (ErrorMessage?) -> Void) {
        PFCloud.callFunction(inBackground: "registration-invitation", withParameters: ["user": user.objectId!]) { responseJSON, error in
            if let success = responseJSON as? Bool, error == nil {
                if success == true {
                    completion(nil)
                    return
                } else {
                    completion(ErrorMessage.invalidInvitationCodeRegistration)
                    return
                }
            } else {
                if let _ = error {
                    completion(ErrorMessage.invalidInvitationCodeRegistration)
                } else {
                    completion(ErrorMessage.unknown)
                }
            }
        }
    }

    func login(withUsername username: String, password: String, completion: @escaping (PFUser?, ErrorMessage?) -> Void) {
        
        guard Reachability.isConnectedToNetwork() else {
            completion(nil, ErrorMessage.NoInternetConnectionRegistration)
            return
        }
        
        self.usernameAvailable(email: username) { (available, error) in
            
            guard let available = available, !available else {
                completion(nil, ErrorMessage.loginNotRegistered)
                return
            }
            
            PFUser.logInWithUsername(inBackground: username, password: password) { (user, error) in
                
                guard let user = user, error == nil else {
                    completion(nil, ErrorMessage.loginWrongPassword)
                    return
                }
                
                user.details.fetchInBackground(block: { (userDetails, error) in
                    guard let userDetails = userDetails as? UserDetails, error == nil else {
                        completion(nil, ErrorMessage.unknown)
                        return
                    }
                    
                    userDetails.gender.fetchInBackground(block: { (object, error) in
                        guard let gender = object as? Gender, error == nil else {
                            completion(nil, ErrorMessage.unknown)
                            return
                        }
                        
                        userDetails.location.fetchInBackground(block: { (object, error) in
                            guard let location = object as? Location, error == nil else {
                                completion(nil, ErrorMessage.unknown)
                                return
                            }
                            
                            user.pinInBackground(block: { (succeeded, error) in
                                if error != nil {
                                    completion(nil, ErrorMessage.unknown)
                                } else {
                                    userDetails.pinInBackground(block: { (success, error) in
                                        if error != nil {
                                            completion(nil, ErrorMessage.unknown)
                                        } else {
                                            gender.pinInBackground(block: { (success, error) in
                                                if error != nil {
                                                    completion(nil, ErrorMessage.unknown)
                                                } else {
                                                    location.pinInBackground(block: { (success, error) in
                                                        if error != nil {
                                                            completion(nil, ErrorMessage.unknown)
                                                        } else {
                                                            PFInstallation.registerUser(user: user)
                                                            completion(user, nil)
                                                        }
                                                    })
                                                }
                                            })
                                        }
                                    })
                                }
                            })
                        })
                    })
                })
            }
        }
    }

    func syncUser(completion: @escaping (ErrorMessage?) -> Void) {
        if !Reachability.isConnectedToNetwork() {
            completion(ErrorMessage.unknown)
            return
        }

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
                    guard let userDetails = userDetails as? UserDetails, error == nil else {
                        if let error = error {
                            completion(ErrorMessage.parseError(error.localizedDescription))
                        } else {
                            completion(ErrorMessage.unknown)
                        }
                        return
                    }
                    
                    userDetails.gender.fetchInBackground(block: { (object, error) in
                        guard let gender = object as? Gender, error == nil else {
                            completion(ErrorMessage.unknown)
                            return
                        }
                        
                        userDetails.location.fetchInBackground(block: { (object, error) in
                            guard let location = object as? Location, error == nil else {
                                completion(ErrorMessage.unknown)
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
                                            gender.pinInBackground(block: { (success, error) in
                                                if error != nil {
                                                    completion(ErrorMessage.parseError(error!.localizedDescription))
                                                } else {
                                                    location.pinInBackground(block: { (success, error) in
                                                        if error != nil {
                                                            completion(ErrorMessage.parseError(error!.localizedDescription))
                                                        } else {
                                                            completion(nil)
                                                        }
                                                    })
                                                }
                                            })
                                        }
                                    })
                                }
                            })
                        })
                    })
                })
            })
        }
    }

    func fetchLocalUser(completion: @escaping (ErrorMessage?) -> Void) {
        if let _ = Session.shared.currentUser {
            let query = PFUser.query()
            query?.fromLocalDatastore()
            query?.includeKey("details")
            query?.includeKey("details.gender")
            query?.includeKey("details.location")
            query?.includeKey("details.language")
            query?.getFirstObjectInBackground(block: { (user, error) in
                guard let _ = user as? PFUser, error == nil else {
                    completion(ErrorMessage.unknown)
                    return
                }

                completion(nil)
            })
        } else {
            completion(ErrorMessage.unknown)
        }
    }

    func usernameAvailable(email: String, completion: @escaping (Bool?, ErrorMessage?) -> Void) {
        let query = PFUser.query()
        query?.whereKey("username", equalTo: email)
        query?.countObjectsInBackground(block: { (count, error) in
            if error != nil {
                completion(nil, ErrorMessage.parseError(error!.localizedDescription))
            } else {
                if count == 0 {
                    completion(true, nil)
                } else {
                    completion(false, nil)
                }
            }
        })
    }

    func logOut(completion: @escaping (ErrorMessage?) -> Void) {
        PFUser.logOutInBackground { error in
            MediaManager.shared.clear()
            
            DispatchQueue.main.async {
                if error != nil {
                    completion(ErrorMessage.parseError(error!.localizedDescription))
                } else {
                    PFObject.unpinAllObjectsInBackground(block: { (success, error) in
                        let names = [
                            LocationManager.shared.pinName,
                            DashboardManager.shared.pinName,
                            MyTeamManager.shared.pinName,
                            AdsViewedManager.shared.pinName,
                            MyMoneyManager.shared.pinName,
                            AdvertManager.shared.pinName,
                        ]
                        
                        for name in names {
                            PFObject.unpinAllObjectsInBackground(withName: name, block: { (success, error) in
                                print("Unpinned \(name): \(success)")
                            })
                        }

                        PFInstallation.registerUser(user: nil)
                        completion(nil)
                    })
                }
            }
        }
    }

    func resetPassword(email: String, completion: @escaping (ErrorMessage?) -> Void) {
        PFUser.requestPasswordResetForEmail(inBackground: email.lowercased(), block: { (success, error) -> Void in
            if error == nil && success == true {
                completion(nil)
            } else {
                print("Error: \(error?.localizedDescription ?? "")")
                completion(ErrorMessage.resetPasswordFailed)
            }
        })
    }

    func changePassword(oldPassword: String, newPassword: String, completion: @escaping (ErrorMessage?) -> Void) {
        guard let user = Session.shared.currentUser else { return }
        let parameters = ["username": user.username!, "oldPassword": oldPassword, "newPassword": newPassword]

        PFCloud.callFunction(inBackground: "change-password", withParameters: parameters) { responseJSON, error in
            if let success = responseJSON as? Bool {
                if success == true {
                    completion(nil)
                    return
                } else {
                    completion(ErrorMessage.unknown)
                    return
                }
            } else if let nsError = error as NSError?,
                      nsError.code == 101  {
                completion(ErrorMessage.invalidCashoutPassword)
            } else {
                completion(ErrorMessage.unknown)
            }
        }
    }

    func deleteAccount(completion: @escaping (ErrorMessage?) -> Void) {
        guard let user = Session.shared.currentUser else { return }

        PFCloud.callFunction(inBackground: "delete-account", withParameters: ["user": user.objectId!]) { responseJSON, error in
            if let success = responseJSON as? Bool {
                if success == true {
                    completion(nil)
                    return
                } else {
                    completion(ErrorMessage.unknown)
                    return
                }
            } else {
                completion(ErrorMessage.unknown)
            }
        }
    }

    func changeTeam(invitationCode: String, completion: @escaping (ErrorMessage?) -> Void) {
        guard let user = Session.shared.currentUser else { return }

        let parameters = ["user": user.objectId!, "invitationCode": invitationCode]

        PFCloud.callFunction(inBackground: "update-invitation-code", withParameters: parameters) { responseJSON, error in
            if let success = responseJSON as? Bool {
                if success == true {
                    user.details.fetchInBackground(block: { (success, error) in
                        completion(nil)
                    })
                } else {
                    completion(ErrorMessage.invalidInvitationCode)
                }
            } else {
                completion(ErrorMessage.unknown)
            }
        }
    }
    
    func fetchGenders(completion: @escaping ([Gender]) -> Void) {
        let query = Gender.query()
        query?.order(byAscending: "index")
        query?.findObjectsInBackground(block: { (objects, error) in
            guard let genders = objects as? [Gender], error == nil else {
                completion([])
                return
            }
            
            completion(genders)
        })
    }
}
