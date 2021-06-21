//
//  AdsViewed.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 22/02/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit
import Foundation
import Parse

final class AdsViewed: PFObject {

    var graph: [Graph] {
        get {
            return self["graph"] as? [Graph] ?? []
        }
        set {
            self["graph"] = newValue
        }
    }

    var targetGraph: [Graph] {
        get {
            return self["targetGraph"] as? [Graph] ?? []
        }
        set {
            self["targetGraph"] = newValue
        }
    }

    var viewed: Int {
        get {
            return self["viewed"] as? Int ?? 0
        }
        set {
            self["viewed"] = newValue
        }
    }

    var adsPerDay: Int {
        get {
            return self["adsPerDay"] as? Int ?? 20
        }
        set {
            self["adsPerDay"] = newValue
        }
    }

    var adBacklog: Int {
        get {
            return self["adBacklog"] as? Int ?? 0
        }
        set {
            self["adBacklog"] = newValue
        }
    }

    var adBacklogThreshold: Int {
        get {
            return self["adsBacklogThreshold"] as? Int ?? 4
        }
        set {
            self["adsBacklogThreshold"] = newValue
        }
    }

    var teamIncomeDuePercentage: Int {
        get {
            return self["teamIncomeDuePercentage"] as? Int ?? 0
        }
        set {
            self["teamIncomeDuePercentage"] = newValue
        }
    }

    var history: [UserMonthStats] {
        get {
            return self["history"] as? [UserMonthStats] ?? []
        }
        set {
            self["history"] = newValue
        }
    }
}

extension AdsViewed: PFSubclassing {
    static func parseClassName() -> String {
        return "AdsViewed"
    }
}
