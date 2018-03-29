//
//  AdvertDetails.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 27/03/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit
import Foundation
import Parse

final class AdvertDetails: PFObject {
    
    var name: String {
        get {
            return self["name"] as? String ?? ""
        }
        set {
            self["name"] = newValue
        }
    }
    
    var title: String? {
        get {
            return self["title"] as? String
        }
        set {
            self["title"] = newValue
        }
    }
    
    var message: String? {
        get {
            return self["message"] as? String
        }
        set {
            self["message"] = newValue
        }
    }
    
    var image: PFFile? {
        get {
            return self["image"] as? PFFile
        }
        set {
            self["image"] = newValue
        }
    }
    
    var template: AdvertTemplate {
        get {
            return self["template"] as! AdvertTemplate
        }
        set {
            self["template"] = newValue
        }
    }
}

extension AdvertDetails: PFSubclassing {
    static func parseClassName() -> String {
        return "AdvertDetails"
    }
}
