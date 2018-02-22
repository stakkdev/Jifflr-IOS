//
//  MyTeamPendingFriends.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 22/02/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit
import Foundation
import Parse

final class MyTeamPendingFriends: PFObject {

    var pendingUser: PendingUser {
        get {
            return self["pendingUser"] as! PendingUser
        }
        set {
            self["pendingUser"] = newValue
        }
    }

    var isActive: Bool {
        get {
            return self["isActive"] as? Bool ?? false
        }
        set {
            self["isActive"] = newValue
        }
    }
}

extension MyTeamPendingFriends: PFSubclassing {
    static func parseClassName() -> String {
        return "MyTeamPendingFriends"
    }
}
