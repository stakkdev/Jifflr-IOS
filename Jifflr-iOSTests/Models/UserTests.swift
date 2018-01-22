//
//  UserTests.swift
//  Ad-M8-iOSTests
//
//  Created by James Shaw on 31/10/2017.
//  Copyright © 2017 The Distance. All rights reserved.
//

import XCTest
import Parse
@testable import Ad_M8_iOS

class UserTests: XCTestCase {

    var user: PFUser!

    override func setUp() {
        super.setUp()

        self.user = PFUser()
        self.user.firstName = "James"
        self.user.lastName = "Shaw"
        self.user.email = "james.shaw@thedistance.co.uk"
        self.user.username = "james.shaw@thedistance.co.uk"
        self.user.password = "test"
        self.user.location = "York, United Kingdom"
        self.user.invitationCode = 2534534
        self.user.gender = "Male"
        self.user.dateOfBirth = Date.distantPast
        self.user.cashAvailable = 0.0
    }

    override func tearDown() {
        self.user = nil
        
        super.tearDown()
    }

    func testAddFriend() {
        let friend = PFUser()
        self.user.addFriend(friend: friend)

        XCTAssertEqual(self.user.friends, [friend])
    }

    func testFetchFriends() {
        self.user.fetchFriends { (friends) in
            XCTAssertEqual(friends, [])
        }
    }

    func testUserGetters() {
        XCTAssertEqual(self.user.firstName, "James")
        XCTAssertEqual(self.user.lastName, "Shaw")
        XCTAssertEqual(self.user.email, "james.shaw@thedistance.co.uk")
        XCTAssertEqual(self.user.username, "james.shaw@thedistance.co.uk")
        XCTAssertEqual(self.user.password, "test")
        XCTAssertEqual(self.user.location, "York, United Kingdom")
        XCTAssertEqual(self.user.invitationCode, 2534534)
        XCTAssertEqual(self.user.gender, "Male")
        XCTAssertEqual(self.user.dateOfBirth, Date.distantPast)
        XCTAssertEqual(self.user.cashAvailable, 0.0)
    }
}
