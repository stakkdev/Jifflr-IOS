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
    
    var index: Int? {
        get {
            return self["index"] as? Int
        }
        set {
            self["index"] = newValue
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
        let query = self.answers.query()
        query.order(byAscending: "index")
        query.findObjectsInBackground { (answers, error) in
            guard let answers = answers, error == nil else {
                completion([])
                return
            }

            completion(answers)
        }
    }
    
    func setAnswers(answers: [Answer]) {
        guard let relation = self.relation(forKey: "answers") as? PFRelation<Answer> else { return }
        
        for answer in answers {
            relation.add(answer)
        }
    }
}
