//
//  UserCashout.swift
//  Ad-M8-iOS
//
//  Created by James Shaw on 13/10/2017.
//  Copyright © 2017 The Distance. All rights reserved.
//

import UIKit
import Foundation
import Parse

final class UserCashout: PFObject {

    var user: PFUser {
        get {
            return self["user"] as! PFUser
        }
        set {
            self["user"] = newValue
        }
    }

    var value: Double {
        get {
            return self["value"] as! Double
        }
        set {
            self["value"] = newValue
        }
    }

    var paypalEmail: String {
        get {
            return self["paypalEmail"] as! String
        }
        set {
            self["paypalEmail"] = newValue
        }
    }
}

extension UserCashout: PFSubclassing {
    static func parseClassName() -> String {
        return "UserCashout"
    }
}
