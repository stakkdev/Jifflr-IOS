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
    }

    var type: Int {
        get {
            return self["type"] as! Int
        }
    }
}

extension LocationStatus: PFSubclassing {
    static func parseClassName() -> String {
        return "LocationStatus"
    }
}
