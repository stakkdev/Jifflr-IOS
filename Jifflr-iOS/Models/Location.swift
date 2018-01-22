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
    }

    var countryName: Int {
        get {
            return self["countryName"] as! Int
        }
    }
}

extension Location: PFSubclassing {
    static func parseClassName() -> String {
        return "Location"
    }
}
