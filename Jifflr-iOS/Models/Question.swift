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

final class Question: PFObject {

    var text: String {
        get {
            return self["text"] as! String
        }
        set {
            self["text"] = newValue
        }
    }

    var type: QuestionType {
        get {
            return self["type"] as! QuestionType
        }
        set {
            self["type"] = newValue
        }
    }

    var answers: PFRelation<Answer> {
        get {
            return self["answers"] as! PFRelation
        }
        set {
            self["answers"] = newValue
        }
    }

    var active: Bool {
        get {
            return self["active"] as? Bool ?? false
        }
        set {
            self["active"] = newValue
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
}

extension Question: PFSubclassing {
    static func parseClassName() -> String {
        return "Question"
    }
}
