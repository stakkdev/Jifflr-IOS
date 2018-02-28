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
        UserDefaults.standard.set(true, forKey: "locationPermissionsRequested")
    }

    func locationPermissionsRequested() -> Bool {
        let viewed = UserDefaults.standard.bool(forKey: "locationPermissionsRequested")
        return viewed
    }

    func crashTrackerOn() -> Bool {
        let on = UserDefaults.standard.bool(forKey: "crashTrackerOn")
        return on
    }

    func setCrashTracker(on: Bool) {
        UserDefaults.standard.set(on, forKey: "crashTrackerOn")
    }

    func analyticsOn() -> Bool {
        let on = UserDefaults.standard.bool(forKey: "analyticsOn")
        return on
    }

    func setAnalytics(on: Bool) {
        UserDefaults.standard.set(on, forKey: "analyticsOn")
    }
}
