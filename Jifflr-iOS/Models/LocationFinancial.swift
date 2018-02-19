//
//  LocationFinancial.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 16/02/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit
import Foundation
import Parse

final class LocationFinancial: PFObject {

    var location: Location {
        get {
            return self["location"] as! Location
        }
    }

    var cpmRateCMS: Int {
        get {
            return self["cpmRateCMS"] as! Int
        }
    }

    var cpmRateExternal: Int {
        get {
            return self["cpmRateExternal"] as! Int
        }
    }
}

extension LocationFinancial: PFSubclassing {
    static func parseClassName() -> String {
        return "LocationFinancial"
    }
}
