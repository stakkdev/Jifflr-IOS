//
//  Graph.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 22/02/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit
import Foundation
import Parse

final class Graph: PFObject {

    var x: Double {
        get {
            return self["x"] as! Double
        }
        set {
            self["x"] = newValue
        }
    }

    var y: Double {
        get {
            return self["y"] as! Double
        }
        set {
            self["y"] = newValue
        }
    }
}

extension Graph: PFSubclassing {
    static func parseClassName() -> String {
        return "Graph"
    }
}
