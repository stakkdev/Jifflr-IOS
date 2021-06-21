//
//  UserFlaggedAd.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 02/05/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit
import Foundation
import Parse

final class UserFlaggedCampaign: PFObject {
    
    var campaign: Campaign {
        get {
            return self["campaign"] as! Campaign
        }
        set {
            self["campaign"] = newValue
        }
    }
    
    var user: PFUser {
        get {
            return self["user"] as! PFUser
        }
        set {
            self["user"] = newValue
        }
    }
    
    var category: ModeratorFeedbackCategory {
        get {
            return self["category"] as! ModeratorFeedbackCategory
        }
        set {
            self["category"] = newValue
        }
    }
}

extension UserFlaggedCampaign: PFSubclassing {
    static func parseClassName() -> String {
        return "UserFlaggedCampaign"
    }
}
