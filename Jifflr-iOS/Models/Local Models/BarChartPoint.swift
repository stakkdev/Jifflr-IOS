//
//  BarChartPoint.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 11/04/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit
import Foundation
import Parse

final class BarChartPoint: PFObject {
    
    var x: String {
        get {
            return self["x"] as! String
        }
        set {
            self["x"] = newValue
        }
    }
    
    var y: Double {
        get {
            return self["y"] as! Double
        }
        set {
            self["y"] = newValue
        }
    }
}

extension BarChartPoint: PFSubclassing {
    static func parseClassName() -> String {
        return "BarChartPoint"
    }
}
