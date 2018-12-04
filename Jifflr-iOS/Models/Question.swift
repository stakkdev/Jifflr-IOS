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
            return self["text"] as? String ?? ""
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
    
    var index: Int? {
        get {
            return self["index"] as? Int
        }
        set {
            self["index"] = newValue
        }
    }
    
    var noOfRequiredAnswers: Int? {
        get {
            return self["noOfRequiredAnswers"] as? Int
        }
        set {
            self["noOfRequiredAnswers"] = newValue
        }
    }
    
    var creator: PFUser? {
        get {
            return self["creator"] as? PFUser
        }
        set {
            self["creator"] = newValue
        }
    }
}

extension Question: PFSubclassing {
    static func parseClassName() -> String {
        return "Question"
    }
}

extension Question {
    func fetchAnswers(completion: @escaping ([Answer]) -> Void) {
        completion(self.answers)
    }
    
    func setAnswers(answers: [Answer]) {
        self.answers = answers
    }
}
