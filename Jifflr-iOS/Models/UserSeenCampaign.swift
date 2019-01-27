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

final class UserSeenCampaign: PFObject {

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

    var campaign: Campaign {
        get {
            return self["campaign"] as! Campaign
        }
        set {
            self["campaign"] = newValue
        }
    }

    var questionAnswers: PFRelation<QuestionAnswers> {
        get {
            return self["questionAnswers"] as! PFRelation
        }
        set {
            self["questionAnswers"] = newValue
        }
    }
    
    var geoPoint: PFGeoPoint? {
        get {
            return self["geoPoint"] as? PFGeoPoint
        }
        set {
            self["geoPoint"] = newValue
        }
    }
}

extension UserSeenCampaign: PFSubclassing {
    static func parseClassName() -> String {
        return "UserSeenCampaign"
    }
}
