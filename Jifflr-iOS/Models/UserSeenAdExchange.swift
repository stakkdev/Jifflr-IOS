//
//  UserSeenAdExchange.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 23/05/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit
import Foundation
import Parse

final class UserSeenAdExchange: PFObject {
    
    var user: PFUser {
        get {
            return self["user"] as! PFUser
        }
        set {
            self["user"] = newValue
        }
    }
    
    var question: AdExchangeQuestion? {
        get {
            return self["question"] as? AdExchangeQuestion
        }
        set {
            self["question"] = newValue
        }
    }
    
    var response1: Bool? {
        get {
            return self["response1"] as? Bool
        }
        set {
            self["response1"] = newValue
        }
    }
    
    var response2: Bool? {
        get {
            return self["response2"] as? Bool
        }
        set {
            self["response2"] = newValue
        }
    }
    
    var response3: Bool? {
        get {
            return self["response3"] as? Bool
        }
        set {
            self["response3"] = newValue
        }
    }
    
    var questionNumber: Int? {
        get {
            return self["questionNumber"] as? Int
        }
        set {
            self["questionNumber"] = newValue
        }
    }
    
    var location: Location? {
        get {
            return self["location"] as? Location
        }
        set {
            self["location"] = newValue
        }
    }
    
    var geoPoint: PFGeoPoint? {
        get {
            return self["geoPoint"] as? PFGeoPoint
        }
        set {
            self["geoPoint"] = newValue
        }
    }
}

extension UserSeenAdExchange: PFSubclassing {
    static func parseClassName() -> String {
        return "UserSeenAdExchange"
    }
}
