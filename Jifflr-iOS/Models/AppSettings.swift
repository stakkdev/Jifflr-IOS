//
//  AppSettings.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 25/04/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit
import Foundation
import Parse

final class AppSettings: PFObject {
    
    var canBecomeModerator: Bool {
        get {
            return self["canBecomeModerator"] as? Bool ?? false
        }
        set {
            self["canBecomeModerator"] = newValue
        }
    }
    
    var questionDuration: Int {
        get {
            return self["questionDuration"] as? Int ?? 5
        }
        set {
            self["questionDuration"] = newValue
        }
    }
    
    var adsSeenCap: Int {
        get {
            return self["adsSeenCap"] as? Int ?? 1200
        }
        set {
            self["adsSeenCap"] = newValue
        }
    }
}

extension AppSettings: PFSubclassing {
    static func parseClassName() -> String {
        return "AppSettings"
    }
}
