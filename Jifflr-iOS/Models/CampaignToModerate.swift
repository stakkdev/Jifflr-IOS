//
//  CampaignToModerate.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 04/07/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit
import Foundation
import Parse

final class CampaignToModerate: PFObject {
    
    var campaign: Campaign {
        get {
            return self["campaign"] as! Campaign
        }
        set {
            self["campaign"] = newValue
        }
    }
}

extension CampaignToModerate: PFSubclassing {
    static func parseClassName() -> String {
        return "CampaignToModerate"
    }
}
