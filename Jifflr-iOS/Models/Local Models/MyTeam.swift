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
}

extension MyTeam: PFSubclassing {
    static func parseClassName() -> String {
        return "MyTeam"
    }
}
