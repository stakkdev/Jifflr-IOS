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
    
    var question1: AdExchangeQuestion? {
        get {
            return self["question1"] as? AdExchangeQuestion
        }
        set {
            self["question1"] = newValue
        }
    }
    
    var response1: Answer? {
        get {
            return self["response1"] as? Answer
        }
        set {
            self["response1"] = newValue
        }
    }
    
    var question2: AdExchangeQuestion? {
        get {
            return self["question2"] as? AdExchangeQuestion
        }
        set {
            self["question2"] = newValue
        }
    }
    
    var response2: Answer? {
        get {
            return self["response2"] as? Answer
        }
        set {
            self["response2"] = newValue
        }
    }
    
    var question3: AdExchangeQuestion? {
        get {
            return self["question3"] as? AdExchangeQuestion
        }
        set {
            self["question3"] = newValue
        }
    }
    
    var response3: Answer? {
        get {
            return self["response3"] as? Answer
        }
        set {
            self["response3"] = newValue
        }
    }
}

extension UserSeenAdExchange: PFSubclassing {
    static func parseClassName() -> String {
        return "UserSeenAdExchange"
    }
}
