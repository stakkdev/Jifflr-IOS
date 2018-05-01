//
//  CampaignDeposit.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 01/05/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit
import Foundation
import Parse

final class CampaignDeposit: PFObject {
    
    var user: PFUser {
        get {
            return self["user"] as! PFUser
        }
        set {
            self["user"] = newValue
        }
    }
    
    var value: Double {
        get {
            return self["value"] as? Double ?? 0.0
        }
        set {
            self["value"] = newValue
        }
    }
}

extension CampaignDeposit: PFSubclassing {
    static func parseClassName() -> String {
        return "CampaignDeposit"
    }
}
