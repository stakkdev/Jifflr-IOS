//
//  UserSeenAdvert.swift
//  Ad-M8-iOS
//
//  Created by James Shaw on 12/10/2017.
//  Copyright © 2017 The Distance. All rights reserved.
//

import UIKit
import Foundation
import Parse

final class UserSeenAdvert: PFObject {

    var user: PFUser {
        get {
            return self["user"] as! PFUser
        }
        set {
            self["user"] = newValue
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

    var advert: Advert {
        get {
            return self["advert"] as! Advert
        }
        set {
            self["advert"] = newValue
        }
    }

    var userFeedback: UserFeedback {
        get {
            return self["userFeedback"] as! UserFeedback
        }
        set {
            self["userFeedback"] = newValue
        }
    }
}

extension UserSeenAdvert: PFSubclassing {
    static func parseClassName() -> String {
        return "UserSeenAdvert"
    }
}
