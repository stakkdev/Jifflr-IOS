//
//  UserSeenAdvertTests.swift
//  Ad-M8-iOSTests
//
//  Created by James Shaw on 31/10/2017.
//  Copyright © 2017 The Distance. All rights reserved.
//

import XCTest
import Parse
@testable import Ad_M8_iOS

class UserSeenAdvertTests: XCTestCase {

    var userSeenAdvert: UserSeenAdvert!
    var userFeedback: UserFeedback!
    var advert: Advert!
    var user: PFUser!
    var location: Location!
    
    override func setUp() {
        super.setUp()

        self.userFeedback = UserFeedback()
        self.userFeedback.likes = true
        self.userFeedback.rating = 5

        self.advert = Advert()
        self.user = PFUser()
        self.location = Location()

        self.userSeenAdvert = UserSeenAdvert()
        self.userSeenAdvert.advert = self.advert
        self.userSeenAdvert.user = self.user
        self.userSeenAdvert.location = self.location
        self.userSeenAdvert.userFeedback = self.userFeedback
    }
    
    override func tearDown() {

        self.userSeenAdvert = nil
        self.userFeedback = nil
        self.advert = nil
        self.user = nil
        self.location = nil

        super.tearDown()
    }

    func testGetters() {
        XCTAssertEqual(self.userSeenAdvert.advert, self.advert)
        XCTAssertEqual(self.userSeenAdvert.userFeedback, self.userFeedback)
        XCTAssertEqual(self.userSeenAdvert.user, self.user)
        XCTAssertEqual(self.userSeenAdvert.location, self.location)
    }
}
