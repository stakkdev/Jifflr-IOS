//
//  ModeratorFeedback.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 30/04/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit
import Foundation
import Parse

final class ModeratorFeedback: PFObject {
    
    var title: String {
        get {
            return self["title"] as! String
        }
        set {
            self["title"] = newValue
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
    
    var category: ModeratorFeedbackCategory {
        get {
            return self["category"] as! ModeratorFeedbackCategory
        }
        set {
            self["category"] = newValue
        }
    }
    
    var index: Int {
        get {
            return self["index"] as? Int ?? 0
        }
        set {
            self["index"] = newValue
        }
    }
    
    var descriptionString: String? {
        get {
            return self["description"] as? String
        }
        set {
            self["description"] = newValue
        }
    }
}

extension ModeratorFeedback: PFSubclassing {
    static func parseClassName() -> String {
        return "ModeratorFeedback"
    }
}
