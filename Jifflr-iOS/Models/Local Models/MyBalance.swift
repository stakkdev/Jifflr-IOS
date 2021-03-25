//
//  MyBalance.swift
//  Jifflr-iOS
//
//  Created by Kristyna Fojtikova on 15/02/2021.
//  Copyright © 2021 The Distance. All rights reserved.
//

import Foundation
import UIKit
import Parse

final class MyBalance: PFObject {
    
    var pinName = "MyBalance"

    var totalBalance: Double {
        get {
            let totalBalance = self["totalBalance"] as? Double ?? 0.0
            return totalBalance == 0.0 ? 0.0 : totalBalance / 100.0
        }
        set {
            self["totalBalance"] = newValue
        }
    }

    var credit: Double {
        get {
            let credit = self["credit"] as? Double ?? 0.0
            return credit == 0.0 ? 0.0 : credit / 100.0
        }
        set {
            self["credit"] = newValue
        }
    }
    
    var availableBalance: Double {
        get {
            let availableBalance = self["availableBalance"] as? Double ?? 0.0
            return availableBalance == 0.0 ? 0.0 : availableBalance / 100.0
        }
        set {
            self["availableBalance"] = newValue
        }
    }


}

extension MyBalance: PFSubclassing {
    static func parseClassName() -> String {
        return "MyBalance"
    }
}
