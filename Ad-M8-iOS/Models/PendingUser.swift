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
        return self["sender"] as! PFUser
    }

    var invitationCode: Int {
        return self["invitationCode"] as! Int
    }

    var name: String {
        return self["name"] as! String
    }

    var email: String {
        return self["email"] as! String
    }
}

extension PendingUser: PFSubclassing {
    static func parseClassName() -> String {
        return "PendingUser"
    }
}
