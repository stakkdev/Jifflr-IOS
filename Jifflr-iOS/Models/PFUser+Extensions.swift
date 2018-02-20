//
//  PFUser+Extensions.swift
//  Ad-M8-iOS
//
//  Created by James Shaw on 09/10/2017.
//  Copyright © 2017 The Distance. All rights reserved.
//

import Foundation
import Parse

extension PFUser {
    var email: String {
        get {
            return self["email"] as! String
        }
        set {
            self["email"] = newValue
        }
    }

    var detailsId: String {
        get {
            return self["detailsId"] as! String
        }
        set {
            self["detailsId"] = newValue
        }
    }

    var details: UserDetails {
        get {
            return self["details"] as! UserDetails
        }
        set {
            self["details"] = newValue
        }
    }

    func canEditInvitationCode() -> Bool {
        guard let createdAt = self.createdAt else {
            return false
        }

        guard let minimumDate = Calendar.current.date(byAdding: .day, value: -14, to: Date()), createdAt > minimumDate else {
            return false
        }

        return true
    }
}
