//
//  LocationStatus.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 16/02/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit
import Foundation
import Parse

final class LocationStatus: PFObject {

    var name: String {
        get {
            return self["name"] as! String
        }
        set {
            self["name"] = newValue
        }
    }

    var type: Int {
        get {
            return self["type"] as! Int
        }
        set {
            self["type"] = newValue
        }
    }
}

extension LocationStatus: PFSubclassing {
    static func parseClassName() -> String {
        return "LocationStatus"
    }
}
