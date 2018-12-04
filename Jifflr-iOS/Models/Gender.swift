//
//  Gender.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 17/04/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit
import Foundation
import Parse

final class Gender: PFObject {
    
    var name: String {
        get {
            return self["name"] as! String
        }
        set {
            self["name"] = newValue
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

extension Gender: PFSubclassing {
    static func parseClassName() -> String {
        return "Gender"
    }
}
