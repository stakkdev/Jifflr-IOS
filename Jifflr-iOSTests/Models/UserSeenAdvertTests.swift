//
//  UserSeenAdvertTests.swift
//  Ad-M8-iOSTests
//
//  Created by James Shaw on 31/10/2017.
//  Copyright © 2017 The Distance. All rights reserved.
//

import XCTest
import Parse
@testable import Jifflr_iOS

class UserSeenAdvertTests: XCTestCase {

    var userSeenAdvert: UserSeenAdvert!
    var advert: Advert!
    var user: PFUser!
    var location: Location!
    
    override func setUp() {
        super.setUp()

        self.advert = Advert()
        self.user = PFUser()
        self.location = Location()

        self.userSeenAdvert = UserSeenAdvert()
        self.userSeenAdvert.advert = self.advert
        self.userSeenAdvert.user = self.user
        self.userSeenAdvert.location = self.location
    }
    
    override func tearDown() {

        self.userSeenAdvert = nil
        self.advert = nil
        self.user = nil
        self.location = nil

        super.tearDown()
    }

    func testGetters() {
        XCTAssertEqual(self.userSeenAdvert.advert, self.advert)
        XCTAssertEqual(self.userSeenAdvert.user, self.user)
        XCTAssertEqual(self.userSeenAdvert.location, self.location)
    }
}
