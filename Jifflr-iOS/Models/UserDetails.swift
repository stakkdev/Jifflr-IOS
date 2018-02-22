//
//  UserDetails.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 16/02/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit
import Foundation
import Parse

final class UserDetails: PFObject {

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

    var location: Location {
        get {
            return self["location"] as! Location
        }
        set {
            self["location"] = newValue
        }
    }

    var displayLocation: String {
        get {
            return self["displayLocation"] as! String
        }
        set {
            self["displayLocation"] = newValue
        }
    }

    var geoPoint: PFGeoPoint {
        get {
            return self["geoPoint"] as! PFGeoPoint
        }
        set {
            self["geoPoint"] = newValue
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

    var invitationCode: String? {
        get {
            return self["invitationCode"] as? String
        }
        set {
            self["invitationCode"] = newValue
        }
    }

    var paypalEmail: String? {
        get {
            return self["paypalEmail"] as? String
        }
        set {
            self["paypalEmail"] = newValue
        }
    }

    var emailVerified: Bool? {
        get {
            return self["emailVerified"] as? Bool ?? false
        }
        set {
            self["emailVerified"] = newValue
        }
    }

    var teamSize: Int {
        get {
            return self["teamSize"] as? Int ?? 0
        }
        set {
            self["teamSize"] = newValue
        }
    }

    var friends: PFRelation<Friends> {
        get {
            return self["friends"] as! PFRelation
        }
        set {
            self["friends"] = newValue
        }
    }
}

extension UserDetails: PFSubclassing {
    static func parseClassName() -> String {
        return "UserDetails"
    }
}