//
//  BinaryFeedback.swift
//  Ad-M8-iOS
//
//  Created by James Shaw on 12/10/2017.
//  Copyright © 2017 The Distance. All rights reserved.
//

import UIKit
import Foundation
import Parse

final class BinaryAdvert: PFObject {

    var like: Bool {
        get {
            return self["like"] as! Bool
        }
        set {
            self["like"] = newValue
        }
    }
}

extension BinaryAdvert: PFSubclassing {
    static func parseClassName() -> String {
        return "BinaryAdvert"
    }
}
