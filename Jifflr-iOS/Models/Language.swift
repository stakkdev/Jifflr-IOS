//
//  Language.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 16/04/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit
import Foundation
import Parse

final class Language: PFObject {
    
    var name: String {
        get {
            return self["name"] as! String
        }
        set {
            self["name"] = newValue
        }
    }
    
    var languageCode: String {
        get {
            return self["languageCode"] as? String ?? ""
        }
        set {
            self["languageCode"] = newValue
        }
    }
}

extension Language: PFSubclassing {
    static func parseClassName() -> String {
        return "Language"
    }
}
