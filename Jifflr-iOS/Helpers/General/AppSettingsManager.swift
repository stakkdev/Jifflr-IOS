//
//  AppSettingsManager.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 25/04/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit
import Parse

class AppSettingsManager: NSObject {
    static let shared = AppSettingsManager()
    
    func canBecomeModerator(completion: @escaping (Bool) -> Void) {
        PFCloud.callFunction(inBackground: "can-become-moderator", withParameters: [:]) { responseJSON, error in
            if let yes = responseJSON as? Bool, error == nil {
                completion(yes)
            } else {
                // TODO - Change to false once endpoint implemented.
                completion(true)
            }
        }
    }
}
