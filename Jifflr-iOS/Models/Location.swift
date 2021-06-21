//
//  Location.swift
//  Ad-M8-iOS
//
//  Created by James Shaw on 12/10/2017.
//  Copyright © 2017 The Distance. All rights reserved.
//

import UIKit
import Foundation
import Parse

final class Location: PFObject {

    var isoCountryCode: String {
        get {
            return self["isoCountryCode"] as! String
        }
        set {
            self["isoCountryCode"] = newValue
        }
    }
    
    var isoCurrencyCode: String {
        get {
            return self["isoCurrencyCode"] as? String ?? "GBP"
        }
        set {
            self["isoCurrencyCode"] = newValue
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

    var locationStatus: LocationStatus {
        get {
            return self["locationStatus"] as! LocationStatus
        }
        set {
            self["locationStatus"] = newValue
        }
    }
}

extension Location: PFSubclassing {
    static func parseClassName() -> String {
        return "Location"
    }
}
