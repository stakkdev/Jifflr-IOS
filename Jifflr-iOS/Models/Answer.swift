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
            return self["text"] as! String
        }
        set {
            self["text"] = newValue
        }
    }

    var image: PFFile {
        get {
            return self["image"] as! PFFile
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
}

extension Answer: PFSubclassing {
    static func parseClassName() -> String {
        return "Answer"
    }
}
