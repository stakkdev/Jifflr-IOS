//
//  Friends.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 16/02/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit
import Foundation
import Parse

final class Friends: PFObject {

    var active: Bool {
        get {
            return self["active"] as? Bool ?? false
        }
        set {
            self["active"] = newValue
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

    var friend: PFUser {
        get {
            return self["friend"] as! PFUser
        }
        set {
            self["friend"] = newValue
        }
    }
}

extension Friends: PFSubclassing {
    static func parseClassName() -> String {
        return "Friends"
    }
}
