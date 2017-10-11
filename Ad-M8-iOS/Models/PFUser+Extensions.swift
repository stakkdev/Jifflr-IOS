//
//  PFUser+Extensions.swift
//  Ad-M8-iOS
//
//  Created by James Shaw on 09/10/2017.
//  Copyright © 2017 The Distance. All rights reserved.
//

import Foundation

import Foundation
import Parse

extension PFUser {
    var firstName: String {
        get {
            return self["firstName"] as! String
        }
        set {
            self["firstName"] = newValue
        }
    }

    var lastName: String {
        get {
            return self["lastName"] as! String
        }
        set {
            self["lastName"] = newValue
        }
    }

    var location: String {
        get {
            return self["location"] as! String
        }
        set {
            self["location"] = newValue
        }
    }

    var dateOfBirth: Date {
        get {
            return self["dateOfBirth"] as! Date
        }
        set {
            self["dateOfBirth"] = newValue
        }
    }

    var gender: String {
        get {
            return self["gender"] as! String
        }
        set {
            self["gender"] = newValue
        }
    }

    var invitationCode: Int {
        get {
            return self["invitationCode"] as! Int
        }
        set {
            self["invitationCode"] = newValue
        }
    }

    var friends: [PFUser] {
        get {
            if let friends = self["friends"] as? [PFUser] {
                return friends
            }
            return []
        }
        set {
            self["friends"] = newValue
        }
    }

    func addFriend(friend: PFUser) {
        var senderFriends = self.friends
        senderFriends.append(friend)
        self.friends = senderFriends
    }

    func fetchFriends(completion: @escaping ([PFUser]) -> Void) {
        guard let currentUser = UserManager.shared.currentUser else {
            completion([])
            return
        }

        let query = PFUser.query()
        query?.includeKey("friends")
        query?.getObjectInBackground(withId: currentUser.objectId!, block: { (user, error) in
            guard let user = user as? PFUser, error == nil else {
                completion([])
                return
            }

            completion(user.friends)
        })
    }
}
