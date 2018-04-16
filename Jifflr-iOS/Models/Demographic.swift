//
//  Demographic.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 16/04/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit
import Foundation
import Parse

final class Demographic: PFObject {
    
    var minAge: Int {
        get {
            return self["minAge"] as! Int
        }
        set {
            self["minAge"] = newValue
        }
    }
    
    var maxAge: Int {
        get {
            return self["maxAge"] as! Int
        }
        set {
            self["maxAge"] = newValue
        }
    }
    
    var genders: [Int] {
        get {
            return self["genders"] as? [Int] ?? []
        }
        set {
            self["genders"] = newValue
        }
    }
    
    var location: Location {
        get {
            return self["location"] as! Location
        }
        set {
            self["location"] = newValue
        }
    }
    
    var language: Language {
        get {
            return self["language"] as! Language
        }
        set {
            self["language"] = newValue
        }
    }
}

extension Demographic: PFSubclassing {
    static func parseClassName() -> String {
        return "Demographic"
    }
}
