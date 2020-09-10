//
//  SettingsManager.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 21/02/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit
import Firebase
import Parse

class SettingsManager: NSObject {
    static let shared = SettingsManager()

    func toggleNotifications(on: Bool) {
        guard let currentUser = Session.shared.currentUser else { return }
        currentUser.details.pushNotifications = on
        currentUser.saveInBackground()
        
        if !on {
            self.removeInstallationDeviceToken()
        } else {
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    func removeInstallationDeviceToken() {
        let installation = PFInstallation.current()
        installation?.setDeviceTokenFrom(nil)
        installation?.saveInBackground()
    }

    func toggleCrashTracker(on: Bool) {
        UserDefaultsManager.shared.setCrashTracker(on: on)
        Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(on)
    }

    func toggleAnalytics(on: Bool) {
        Analytics.setAnalyticsCollectionEnabled(on)
        UserDefaultsManager.shared.setAnalytics(on: on)
    }
}
