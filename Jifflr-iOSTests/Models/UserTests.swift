//
//  UserTests.swift
//  Ad-M8-iOSTests
//
//  Created by James Shaw on 31/10/2017.
//  Copyright © 2017 The Distance. All rights reserved.
//

import XCTest
import Parse
@testable import Jifflr_iOS

class UserTests: XCTestCase {

    var user: PFUser!

    override func setUp() {
        super.setUp()

        let location = Location()
        location.name = "United Kingdom"
        location.isoCountryCode = "GB"

        let userDetails = UserDetails()
        userDetails.firstName = "James"
        userDetails.lastName = "Shaw"
        userDetails.dateOfBirth = Date.distantPast
        userDetails.gender = "Male"
        userDetails.emailVerified = false
        userDetails.location = location
        userDetails.geoPoint = PFGeoPoint(latitude: 53.14, longitude: -1.01)
        userDetails.displayLocation = "York, United Kingdom"
        userDetails.invitationCode = "vyi7hHjsd"

        self.user = PFUser()
        self.user.details = userDetails
        self.user.email = "james.shaw@thedistance.co.uk"
        self.user.password = "test"
        self.user.username = "james.shaw@thedistance.co.uk"
    }

    override func tearDown() {
        self.user = nil
        
        super.tearDown()
    }

    func testUserGetters() {
        XCTAssertEqual(self.user.details.firstName, "James")
        XCTAssertEqual(self.user.details.lastName, "Shaw")
        XCTAssertEqual(self.user.email, "james.shaw@thedistance.co.uk")
        XCTAssertEqual(self.user.username, "james.shaw@thedistance.co.uk")
        XCTAssertEqual(self.user.password, "test")
        XCTAssertEqual(self.user.details.displayLocation, "York, United Kingdom")
        XCTAssertEqual(self.user.details.invitationCode, "vyi7hHjsd")
        XCTAssertEqual(self.user.details.gender, "Male")
        XCTAssertEqual(self.user.details.dateOfBirth, Date.distantPast)
    }
}
