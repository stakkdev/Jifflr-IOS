//
//  UserDefaultsManager.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 09/02/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit

class UserDefaultsManager: NSObject {
    static let shared = UserDefaultsManager()

    func onboardingViewed() -> Bool {
        let viewed = UserDefaults.standard.bool(forKey: "onboardingViewed")
        return viewed
    }

    func setOnboardingViewed() {
        UserDefaults.standard.set(true, forKey: "onboardingViewed")
    }

    func setLocationPermissionsRequested() {
        UserDefaults.standard.set(true, forKey: "onboardingViewed")
    }

    func locationPermissionsRequested() -> Bool {
        let viewed = UserDefaults.standard.bool(forKey: "locationPermissionsRequested")
        return viewed
    }
}
