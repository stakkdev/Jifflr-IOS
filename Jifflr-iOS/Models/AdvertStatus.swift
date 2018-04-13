//
//  AdvertStatus.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 11/04/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit
import Foundation
import Parse

final class AdvertStatus: PFObject {
    
    var name: String {
        get {
            return self["name"] as! String
        }
        set {
            self["name"] = newValue
        }
    }
    
    var key: String {
        get {
            return self["key"] as! String
        }
        set {
            self["key"] = newValue
        }
    }
}

extension AdvertStatus: PFSubclassing {
    static func parseClassName() -> String {
        return "AdvertStatus"
    }
}
