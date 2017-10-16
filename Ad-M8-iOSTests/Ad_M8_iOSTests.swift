//
//  Ad_M8_iOSTests.swift
//  Ad-M8-iOSTests
//
//  Created by James Shaw on 09/10/2017.
//  Copyright © 2017 The Distance. All rights reserved.
//

import XCTest
import Parse
@testable import Ad_M8_iOS

class Ad_M8_iOSTests: XCTestCase {

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
        self.user.dateOfBirth = Date()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAddFriend() {
        let friend = PFUser()
        self.user.addFriend(friend: friend)

        XCTAssertEqual(self.user.friends, [friend])
    }
}
