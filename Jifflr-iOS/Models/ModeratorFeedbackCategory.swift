//
//  ModeratorFeedbackCategory.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 30/04/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit
import Foundation
import Parse

final class ModeratorFeedbackCategory: PFObject {
    
    var title: String {
        get {
            return self["title"] as! String
        }
        set {
            self["title"] = newValue
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
    
    var passed: Bool {
        get {
            return self["passed"] as? Bool ?? false
        }
        set {
            self["passed"] = newValue
        }
    }
}

extension ModeratorFeedbackCategory: PFSubclassing {
    static func parseClassName() -> String {
        return "ModeratorFeedbackCategory"
    }
}
