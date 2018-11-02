//
//  UserMonthStats.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 22/02/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit
import Foundation
import Parse

final class UserMonthStats: PFObject {

    var adBacklog: Int {
        get {
            return self["adBacklog"] as? Int ?? 0
        }
        set {
            self["adBacklog"] = newValue
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

    var percentage: Int {
        get {
            return self["percentage"] as? Int ?? 0
        }
        set {
            self["percentage"] = newValue
        }
    }
    
    var period: String {
        get {
            return self["period"] as? String ?? ""
        }
        set {
            self["period"] = newValue
        }
    }
}

extension UserMonthStats: PFSubclassing {
    static func parseClassName() -> String {
        return "UserMonthStats"
    }
}
