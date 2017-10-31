//
//  RegistrationViewControllerTests.swift
//  Ad-M8-iOSTests
//
//  Created by James Shaw on 31/10/2017.
//  Copyright © 2017 The Distance. All rights reserved.
//

import XCTest
@testable import Ad_M8_iOS

class RegistrationViewControllerTests: XCTestCase {

    var vc: RegisterViewController!
    
    override func setUp() {
        super.setUp()

        self.vc = RegisterViewController.instantiateFromStoryboard()
        _ = self.vc.view
    }
    
    override func tearDown() {
        self.vc = nil

        super.tearDown()
    }

    func testLocationFound() {
        let userInfo:[String: String] = ["location": "31 Micklegate, York"]
        let notification = NSNotification(name: Constants.Notifications.locationFound, object: self, userInfo: userInfo)
        self.vc.locationFound(notification)

        XCTAssertEqual(self.vc.locationTextField.text, "31 Micklegate, York")
    }
}
