//
//  AdTemplate.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 26/03/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit
import Foundation
import Parse

final class AdvertTemplate: PFObject {
    
    var text: String {
        get {
            return self["text"] as! String
        }
    }
    
    var index: Int {
        get {
            return self["index"] as! Int
        }
    }
    
    var image: PFFile? {
        get {
            return self["image"] as? PFFile
        }
    }
    
    var key: String {
        get {
            return self["key"] as! String
        }
    }
}

extension AdvertTemplate: PFSubclassing {
    static func parseClassName() -> String {
        return "AdvertTemplate"
    }
}
