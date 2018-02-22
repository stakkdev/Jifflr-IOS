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

    var graph: [Graph] {
        get {
            return self["graph"] as? [Graph] ?? []
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

    var friends: [MyTeamFriends] {
        get {
            return self["friends"] as? [MyTeamFriends] ?? []
        }
        set {
            self["friends"] = newValue
        }
    }

    var pendingFriends: [MyTeamPendingFriends] {
        get {
            return self["pendingFriends"] as? [MyTeamPendingFriends] ?? []
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
