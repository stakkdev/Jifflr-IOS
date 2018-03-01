//
//  MyMoney.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 28/02/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import Foundation
import UIKit
import Parse

final class MyMoney: PFObject {

    var graph: [Graph] {
        get {
            return self["graph"] as? [Graph] ?? []
        }
        set {
            self["graph"] = newValue
        }
    }

    var totalWithdrawn: Double {
        get {
            return self["totalWithdrawn"] as? Double ?? 0.0
        }
        set {
            self["totalWithdrawn"] = newValue
        }
    }

    var moneyAvailable: Double {
        get {
            return self["moneyAvailable"] as? Double ?? 0.0
        }
        set {
            self["moneyAvailable"] = newValue
        }
    }

    var history: [UserCashout] {
        get {
            return self["history"] as? [UserCashout] ?? []
        }
        set {
            self["history"] = newValue
        }
    }
}

extension MyMoney: PFSubclassing {
    static func parseClassName() -> String {
        return "MyMoney"
    }
}
