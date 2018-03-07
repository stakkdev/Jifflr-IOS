//
//  QuestionAnswers.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 06/03/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit
import Foundation
import Parse

final class QuestionAnswers: PFObject {

    var question: Question {
        get {
            return self["question"] as! Question
        }
        set {
            self["question"] = newValue
        }
    }

    var answers: [String] {
        get {
            return self["answers"] as? [String] ?? []
        }
        set {
            self["answers"] = newValue
        }
    }
}

extension QuestionAnswers: PFSubclassing {
    static func parseClassName() -> String {
        return "QuestionAnswers"
    }
}
