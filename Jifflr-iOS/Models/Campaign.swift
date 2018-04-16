//
//  Campaign.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 16/04/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit
import Foundation
import Parse

final class Campaign: PFObject {
    
    var advert: Advert {
        get {
            return self["advert"] as! Advert
        }
        set {
            self["advert"] = newValue
        }
    }
    
    var demographic: Demographic {
        get {
            return self["demographic"] as! Demographic
        }
        set {
            self["demographic"] = newValue
        }
    }
    
    var schedule: Schedule {
        get {
            return self["schedule"] as! Schedule
        }
        set {
            self["schedule"] = newValue
        }
    }
    
    var budget: Float {
        get {
            return self["budget"] as? Float ?? 0.0
        }
        set {
            self["budget"] = newValue
        }
    }
    
    var name: String {
        get {
            return self["name"] as! String
        }
        set {
            self["name"] = newValue
        }
    }
    
    var locationFinancial: LocationFinancial {
        get {
            return self["locationFinancial"] as! LocationFinancial
        }
        set {
            self["locationFinancial"] = newValue
        }
    }
}

extension Campaign: PFSubclassing {
    static func parseClassName() -> String {
        return "Campaign"
    }
}
