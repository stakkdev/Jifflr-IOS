//
//  Answer.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 02/03/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit
import Foundation
import Parse

final class Answer: PFObject {

    var text: String {
        get {
            return self["text"] as? String ?? ""
        }
        set {
            self["text"] = newValue
        }
    }

    var image: PFFileObject? {
        get {
            return self["image"] as? PFFileObject
        }
        set {
            self["image"] = newValue
        }
    }

    var index: Int {
        get {
            return self["index"] as! Int
        }
        set {
            self["index"] = newValue
        }
    }
    
    var date: Date? {
        get {
            return self["date"] as? Date
        }
        set {
            self["date"] = newValue
        }
    }
    
    var questionType: QuestionType? {
        get {
            return self["questionType"] as? QuestionType
        }
        set {
            self["questionType"] = newValue
        }
    }
    
    var urlType: String {
        get {
            return self["urlType"] as? String ?? ""
        }
        set {
            self["urlType"] = newValue
        }
    }
}

extension Answer: PFSubclassing {
    static func parseClassName() -> String {
        return "Answer"
    }
}
