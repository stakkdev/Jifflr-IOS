//
//  FeedbackType.swift
//  Ad-M8-iOS
//
//  Created by James Shaw on 12/10/2017.
//  Copyright © 2017 The Distance. All rights reserved.
//

import UIKit
import Foundation
import Parse

final class QuestionType: PFObject {

    var name: String {
        get {
            return self["name"] as! String
        }
    }

    var type: Int {
        get {
            return self["type"] as! Int
        }
    }
}

extension QuestionType: PFSubclassing {
    static func parseClassName() -> String {
        return "QuestionType"
    }
}
