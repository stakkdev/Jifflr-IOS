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
            if let responseJSON = responseJSON as? [String: Bool], error == nil {
                if let yes = responseJSON["success"] {
                    completion(yes)
                } else {
                    completion(false)
                }
            } else {
                completion(false)
            }
        }
    }
}
