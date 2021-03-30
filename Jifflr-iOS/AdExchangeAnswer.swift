//
//  AdExchangeAnswer.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 30/03/2021.
//  Copyright © 2021 The Distance. All rights reserved.
//

import UIKit
import Foundation
import Parse

final class AdExchangeAnswer: PFObject {
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
}

extension AdExchangeAnswer: PFSubclassing {
    static func parseClassName() -> String {
        return "AdExchangeAnswer"
    }
}
