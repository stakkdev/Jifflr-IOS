//
//  UserFeedback.swift
//  Ad-M8-iOS
//
//  Created by James Shaw on 12/10/2017.
//  Copyright © 2017 The Distance. All rights reserved.
//

import UIKit
import Foundation
import Parse

final class UserFeedback: PFObject {

    var likes: Bool? {
        get {
            return self["likes"] as? Bool
        }
        set {
            self["likes"] = newValue
        }
    }

    var rating: Int? {
        get {
            return self["rating"] as? Int
        }
        set {
            self["rating"] = newValue
        }
    }
}

extension UserFeedback: PFSubclassing {
    static func parseClassName() -> String {
        return "UserFeedback"
    }
}
