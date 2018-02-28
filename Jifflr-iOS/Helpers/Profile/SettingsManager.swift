//
//  SettingsManager.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 21/02/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit
import Firebase
import Fabric
import Crashlytics

class SettingsManager: NSObject {
    static let shared = SettingsManager()

    func toggleNotifications(on: Bool) {
        guard let currentUser = Session.shared.currentUser else { return }
        currentUser.details.pushNotifications = on
        currentUser.saveInBackground()
    }

    func toggleCrashTracker(on: Bool) {
        UserDefaultsManager.shared.setCrashTracker(on: on)
    }

    func toggleAnalytics(on: Bool) {
        AnalyticsConfiguration.shared().setAnalyticsCollectionEnabled(on)
        UserDefaultsManager.shared.setAnalytics(on: on)
    }
}
