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

    var feedbackType: FeedbackType {
        get {
            return self["feedbackType"] as! FeedbackType
        }
        set {
            self["feedbackType"] = newValue
        }
    }

    var feedbackQuestion: FeedbackQuestion {
        get {
            return self["feedbackQuestion"] as! FeedbackQuestion
        }
        set {
            self["feedbackQuestion"] = newValue
        }
    }
}

extension Advert: PFSubclassing {
    static func parseClassName() -> String {
        return "Advert"
    }
}
