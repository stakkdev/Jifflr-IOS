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

    var question: Question {
        get {
            return self["question"] as! Question
        }
        set {
            self["question"] = newValue
        }
    }

    var chosenAnswers: PFRelation<Answer> {
        get {
            return self["chosenAnswers"] as! PFRelation
        }
        set {
            self["chosenAnswers"] = newValue
        }
    }
}

extension UserSeenAdvert: PFSubclassing {
    static func parseClassName() -> String {
        return "UserSeenAdvert"
    }
}
