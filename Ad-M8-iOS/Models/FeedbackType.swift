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

final class FeedbackType: PFObject {

    var title: String {
        get {
            return self["title"] as! String
        }
    }

    var id: Int {
        get {
            return self["feedbackTypeId"] as! Int
        }
    }
}

extension FeedbackType: PFSubclassing {
    static func parseClassName() -> String {
        return "FeedbackType"
    }
}
