//
//  Schedule.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 16/04/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit
import Foundation
import Parse

final class Schedule: PFObject {
    
    var startDate: Date {
        get {
            return self["startDate"] as! Date
        }
        set {
            self["startDate"] = newValue
        }
    }
    
    var endDate: Date {
        get {
            return self["endDate"] as! Date
        }
        set {
            self["endDate"] = newValue
        }
    }
    
    var daysOfWeek: [Int] {
        get {
            return self["daysOfWeek"] as? [Int] ?? []
        }
        set {
            self["daysOfWeek"] = newValue
        }
    }
}

extension Schedule: PFSubclassing {
    static func parseClassName() -> String {
        return "Schedule"
    }
}
