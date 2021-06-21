//
//  AdTrackingManager.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 01/10/2020.
//  Copyright © 2020 The Distance. All rights reserved.
//

import UIKit
import AppTrackingTransparency

class AdTrackingManager: NSObject {
    static let shared = AdTrackingManager()
    
    func adTrackingEnabled() -> Bool {
        if #available(iOS 14, *) {
            return ATTrackingManager.trackingAuthorizationStatus == .authorized
        } else {
            return true
        }
    }
    
    func requestPermissions(completion: @escaping (Bool) -> Void) {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { (status) in
                UserDefaultsManager.shared.setAppTrackingRequested()
                completion(status == .authorized)
            }
        } else {
            completion(true)
        }
    }
}
