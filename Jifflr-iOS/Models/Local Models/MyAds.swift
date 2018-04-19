//
//  MyAds.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 11/04/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import Foundation
import UIKit
import Parse

final class MyAds: PFObject {
    
    var activeAds: Int {
        get {
            return self["activeAds"] as! Int
        }
        set {
            self["activeAds"] = newValue
        }
    }
    
    var adverts: [Advert] {
        get {
            return self["adverts"] as? [Advert] ?? []
        }
        set {
            self["adverts"] = newValue
        }
    }
    
    var graph: [BarChartPoint] {
        get {
            return self["graph"] as? [BarChartPoint] ?? []
        }
        set {
            self["graph"] = newValue
        }
    }
    
    var campaigns: [Campaign] {
        get {
            return self["campaign"] as? [Campaign] ?? []
        }
        set {
            self["campaign"] = newValue
        }
    }
    
    var campaignCount: Int {
        get {
            return self["campaignCount"] as? Int ?? 0
        }
        set {
            self["campaignCount"] = newValue
        }
    }
}

extension MyAds: PFSubclassing {
    static func parseClassName() -> String {
        return "MyAds"
    }
}
