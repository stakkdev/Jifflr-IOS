//
//  AdExchangeQuestion.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 23/05/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit
import Foundation
import Parse

final class AdExchangeQuestion: PFObject {
    
    var question: String {
        get {
            return self["question"] as! String
        }
        set {
            self["question"] = newValue
        }
    }
    
    var questionNumber: Int {
        get {
            return self["questionNumber"] as? Int ?? 0
        }
        set {
            self["questionNumber"] = newValue
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
    
    var image1: PFFileObject? {
        get {
            return self["image1"] as? PFFileObject
        }
        set {
            self["image1"] = newValue
        }
    }
    
    var image2: PFFileObject? {
        get {
            return self["image2"] as? PFFileObject
        }
        set {
            self["image2"] = newValue
        }
    }
    
    var image3: PFFileObject? {
        get {
            return self["image3"] as? PFFileObject
        }
        set {
            self["image3"] = newValue
        }
    }
}

extension AdExchangeQuestion: PFSubclassing {
    static func parseClassName() -> String {
        return "AdExchangeQuestion"
    }
}
