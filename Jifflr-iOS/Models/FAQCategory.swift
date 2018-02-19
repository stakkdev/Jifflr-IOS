//
//  FAQCategory.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 19/02/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit
import Foundation
import Parse

final class FAQCategory: PFObject {

    var name: String {
        get {
            return self["name"] as! String
        }
    }

    var index: Int {
        get {
            return self["index"] as! Int
        }
    }
}

extension FAQCategory: PFSubclassing {
    static func parseClassName() -> String {
        return "FAQCategory"
    }
}
