//
//  PendingUser.swift
//  Ad-M8-iOS
//
//  Created by James Shaw on 10/10/2017.
//  Copyright © 2017 The Distance. All rights reserved.
//

import UIKit
import Foundation
import Parse

final class PendingUser: PFObject {

    var sender: PFUser {
        get {
            return self["sender"] as! PFUser
        }
        set {
            self["sender"] = newValue
        }
    }

    var invitationCode: String {
        get {
            return self.objectId!
        }
    }

    var name: String {
        get {
            return self["name"] as! String
        }
        set {
            self["name"] = newValue
        }
    }

    var email: String {
        get {
            return self["email"] as! String
        }
        set {
            self["email"] = newValue
        }
    }
}

extension PendingUser: PFSubclassing {
    static func parseClassName() -> String {
        return "PendingUser"
    }
}
