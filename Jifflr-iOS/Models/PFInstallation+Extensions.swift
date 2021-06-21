//
//  PFInstallation+Extensions.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 28/02/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import Foundation
import Parse

extension PFInstallation {
    var user: PFUser? {
        get {
            return self["user"] as? PFUser
        }
        set {
            if newValue == nil {
                self["user"] = NSNull()
            } else {
                self["user"] = newValue
            }
        }
    }

    static func registerUser(user: PFUser?) {
        let installation = PFInstallation.current()
        installation?.user = user
        installation?.saveInBackground()
    }
}
