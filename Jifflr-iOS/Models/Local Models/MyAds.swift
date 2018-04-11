//
//  MyAds.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 11/04/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import Foundation
import UIKit
import Parse

final class MyAds: PFObject {
    
    var activeAds: Int {
        get {
            return self["activeAds"] as! Int
        }
        set {
            self["activeAds"] = newValue
        }
    }
    
    var adverts: [Advert] {
        get {
            return self["adverts"] as? [Advert] ?? []
        }
        set {
            self["adverts"] = newValue
        }
    }
}

extension MyAds: PFSubclassing {
    static func parseClassName() -> String {
        return "MyAds"
    }
}
