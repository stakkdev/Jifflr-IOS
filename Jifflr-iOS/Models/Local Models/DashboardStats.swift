//
//  DashboardStats.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 21/02/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit
import Foundation
import Parse

final class DashboardStats: PFObject {

    var teamSize: Int {
        get {
            return self["teamSize"] as? Int ?? 0
        }
        set {
            self["teamSize"] = newValue
        }
    }

    var adsViewed: Int {
        get {
            return self["adsViewed"] as? Int ?? 0
        }
        set {
            self["adsViewed"] = newValue
        }
    }

    var money: Double {
        get {
            let money = self["money"] as? Double ?? 0.0
            return money == 0.0 ? 0.0 : money / 100.0
        }
        set {
            self["money"] = newValue
        }
    }

    var adsCreated: Int {
        get {
            return self["adsCreated"] as? Int ?? 0
        }
        set {
            self["adsCreated"] = newValue
        }
    }
}

extension DashboardStats: PFSubclassing {
    static func parseClassName() -> String {
        return "DashboardStats"
    }
}
