//
//  Advert.swift
//  Ad-M8-iOS
//
//  Created by James Shaw on 12/10/2017.
//  Copyright © 2017 The Distance. All rights reserved.
//

import UIKit
import Foundation
import Parse

final class Advert: PFObject {

    var questions: [Question] {
        get {
            return self["questions"] as? [Question] ?? []
        }
        set {
            self["questions"] = newValue
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

    var isCMS: Bool {
        get {
            return self["isCMS"] as? Bool ?? true
        }
        set {
            self["isCMS"] = newValue
        }
    }
    
    var details: AdvertDetails? {
        get {
            return self["details"] as? AdvertDetails
        }
        set {
            self["details"] = newValue
        }
    }
}

extension Advert: PFSubclassing {
    static func parseClassName() -> String {
        return "Advert"
    }
}

extension Advert {
    func addQuestions(questions: [Question]) {
        self.questions = questions
    }
}
