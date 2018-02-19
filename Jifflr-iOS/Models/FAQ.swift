//
//  FAQ.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 19/02/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit
import Foundation
import Parse

final class FAQ: PFObject {

    var title: String {
        get {
            return self["title"] as! String
        }
    }

    var descriptionText: String {
        get {
            return self["description"] as! String
        }
    }

    var category: FAQCategory {
        get {
            return self["category"] as! FAQCategory
        }
    }

    var categoryId: String {
        get {
            return self["categoryId"] as! String
        }
    }

    var languageCode: String {
        get {
            return self["languageCode"] as! String
        }
    }

    var index: Int {
        get {
            return self["index"] as? Int ?? 0
        }
    }
}

extension FAQ: PFSubclassing {
    static func parseClassName() -> String {
        return "FAQ"
    }
}
