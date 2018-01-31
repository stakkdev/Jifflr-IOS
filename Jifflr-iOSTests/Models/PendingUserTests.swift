//
//  PendingUserTests.swift
//  Ad-M8-iOSTests
//
//  Created by James Shaw on 31/10/2017.
//  Copyright © 2017 The Distance. All rights reserved.
//

import XCTest
import Parse
@testable import Jifflr_iOS

class PendingUserTests: XCTestCase {

    var pendingUser: PendingUser!
    var user: PFUser!

    override func setUp() {
        super.setUp()

        self.user = PFUser()

        self.pendingUser = PendingUser()
        self.pendingUser.name = "Bob Smith"
        self.pendingUser.sender = self.user
        self.pendingUser.email = "bob.smith@thedistance.co.uk"
        self.pendingUser.invitationCode = 2534534
    }

    override func tearDown() {
        self.user = nil
        self.pendingUser = nil

        super.tearDown()
    }

    func testPendingUserGetters() {
        XCTAssertEqual(self.pendingUser.name, "Bob Smith")
        XCTAssertEqual(self.pendingUser.sender, self.user)
        XCTAssertEqual(self.pendingUser.email, "bob.smith@thedistance.co.uk")
        XCTAssertEqual(self.pendingUser.invitationCode, 2534534)
    }
}
