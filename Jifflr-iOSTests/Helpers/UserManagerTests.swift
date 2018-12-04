//
//  UserManagerTests.swift
//  Ad-M8-iOSTests
//
//  Created by James Shaw on 31/10/2017.
//  Copyright © 2017 The Distance. All rights reserved.
//

import XCTest
@testable import Jifflr_iOS


class UserManagerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testLogin() {
        let loginExpectation = expectation(description: "Call Login using UserManager to login to Parse")

        UserManager.shared.login(withUsername: "james.shaw@thedistance.co.uk", password: "test") { (user, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(user)

            loginExpectation.fulfill()
        }

        waitForExpectations(timeout: 5) { (error) in
            if let error = error {
                XCTFail("waitForExpectationsTimeOut: \(error)")
            }
        }
    }

    func testLogOut() {
        let logOutExpectation = expectation(description: "Call Logout using UserManager to logout of Parse")

        UserManager.shared.logOut { (error) in
            XCTAssertNil(error)

            logOutExpectation.fulfill()
        }

        waitForExpectations(timeout: 5) { (error) in
            if let error = error {
                XCTFail("waitForExpectationsTimeOut: \(error)")
            }
        }
    }
}
