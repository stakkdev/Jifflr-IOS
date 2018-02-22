//
//  MyTeamFriends.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 22/02/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit
import Foundation
import Parse

final class MyTeamFriends: PFObject {

    var user: PFUser {
        get {
            return self["user"] as! PFUser
        }
        set {
            self["user"] = newValue
        }
    }

    var teamSize: Int {
        get {
            return self["teamSize"] as? Int ?? 0
        }
        set {
            self["teamSize"] = newValue
        }
    }
}

extension MyTeamFriends: PFSubclassing {
    static func parseClassName() -> String {
        return "MyTeamFriends"
    }
}
