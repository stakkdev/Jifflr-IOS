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
    
    var location: Location {
        get {
            return self["location"] as! Location
        }
        set {
            self["location"] = newValue
        }
    }
    
    var number: Int {
        get {
            return self["number"] as? Int ?? 0
        }
        set {
            self["number"] = newValue
        }
    }
    
    var text: String {
        get {
            return self["text"] as! String
        }
        set {
            self["text"] = newValue
        }
    }
    
    var image: PFFile? {
        get {
            return self["image"] as? PFFile
        }
        set {
            self["image"] = newValue
        }
    }
    
    var answers: [Answer] {
        get {
            return self["answers"] as? [Answer] ?? []
        }
        set {
            self["answers"] = newValue
        }
    }
    
    var active: Bool {
        get {
            return self["active"] as? Bool ?? true
        }
        set {
            self["active"] = newValue
        }
    }
}

extension AdExchangeQuestion: PFSubclassing {
    static func parseClassName() -> String {
        return "AdExchangeQuestion"
    }
}
