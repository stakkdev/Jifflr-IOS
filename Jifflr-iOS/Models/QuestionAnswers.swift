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

    var answers: PFRelation<Answer> {
        get {
            return self["answers"] as! PFRelation
        }
        set {
            self["answers"] = newValue
        }
    }
    
    var answerObjectIds: [String] {
        get {
            return self["answerObjectIds"] as? [String] ?? []
        }
        set {
            self["answerObjectIds"] = newValue
        }
    }
}

extension QuestionAnswers: PFSubclassing {
    static func parseClassName() -> String {
        return "QuestionAnswers"
    }
}
