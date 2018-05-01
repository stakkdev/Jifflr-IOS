//
//  ModeratorAdReview.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 01/05/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit
import Foundation
import Parse

final class ModeratorAdReview: PFObject {
    
    var advert: Advert {
        get {
            return self["advert"] as! Advert
        }
        set {
            self["advert"] = newValue
        }
    }
    
    var moderator: PFUser {
        get {
            return self["moderator"] as! PFUser
        }
        set {
            self["moderator"] = newValue
        }
    }
    
    var feedback: [ModeratorFeedback] {
        get {
            return self["feedback"] as? [ModeratorFeedback] ?? []
        }
        set {
            self["feedback"] = newValue
        }
    }
    
    var approved: Bool {
        get {
            return self["approved"] as? Bool ?? false
        }
        set {
            self["approved"] = newValue
        }
    }
}

extension ModeratorAdReview: PFSubclassing {
    static func parseClassName() -> String {
        return "ModeratorAdReview"
    }
}
