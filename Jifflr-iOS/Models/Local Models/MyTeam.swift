//
//  MyTeam.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 16/02/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit
import Foundation
import Parse

final class MyTeam: PFObject {

    var graph: [(x: Double, y: Double)] {
        get {
            return self["graph"] as? [(x: Double, y: Double)] ?? []
        }
        set {
            self["graph"] = newValue
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

    var friends: [(user: PFUser, teamSize: Int)] {
        get {
            return self["friends"] as? [(user: PFUser, teamSize: Int)] ?? []
        }
        set {
            self["friends"] = newValue
        }
    }

    var pendingFriends: [(user: PFUser, isActive: Bool)] {
        get {
            return self["pendingFriends"] as? [(user: PFUser, isActive: Bool)] ?? []
        }
        set {
            self["pendingFriends"] = newValue
        }
    }
}

extension MyTeam: PFSubclassing {
    static func parseClassName() -> String {
        return "MyTeam"
    }
}
