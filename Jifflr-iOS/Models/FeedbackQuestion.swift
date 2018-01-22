//
//  FeedbackQuestion.swift
//  Ad-M8-iOS
//
//  Created by James Shaw on 12/10/2017.
//  Copyright © 2017 The Distance. All rights reserved.
//

import UIKit
import Foundation
import Parse

final class FeedbackQuestion: PFObject {

    var question: String {
        get {
            return self["question"] as! String
        }
        set {
            self["question"] = newValue
        }
    }
}

extension FeedbackQuestion: PFSubclassing {
    static func parseClassName() -> String {
        return "FeedbackQuestion"
    }
}
