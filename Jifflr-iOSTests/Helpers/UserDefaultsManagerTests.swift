//
//  UserDefaultsManagerTests.swift
//  Jifflr-iOSTests
//
//  Created by James Shaw on 25/02/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import XCTest
@testable import Jifflr_iOS

class UserDefaultsManagerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testOnboardingViewed() {
        UserDefaultsManager.shared.setOnboardingViewed()
        let viewed = UserDefaultsManager.shared.onboardingViewed()
        XCTAssertEqual(viewed, true)
    }

    func testLocationPermissions() {
        UserDefaultsManager.shared.setLocationPermissionsRequested()
        let requested = UserDefaultsManager.shared.locationPermissionsRequested()
        XCTAssertEqual(requested, true)
    }

    func testNotifications() {
        UserDefaultsManager.shared.setNotifications(on: true)
        let notifications = UserDefaultsManager.shared.notificationsOn()
        XCTAssertEqual(notifications, true)
    }

    func testCrashTracker() {
        UserDefaultsManager.shared.setCrashTracker(on: true)
        let on = UserDefaultsManager.shared.crashTrackerOn()
        XCTAssertEqual(on, true)
    }

    func testAnalytics() {
        UserDefaultsManager.shared.setAnalytics(on: true)
        let on = UserDefaultsManager.shared.analyticsOn()
        XCTAssertEqual(on, true)
    }
}
