//
//  TeamPaginationManagerTests.swift
//  Jifflr-iOSTests
//
//  Created by James Shaw on 25/02/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import XCTest
@testable import Jifflr_iOS

class TeamPaginationManagerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testShouldPaginateFriendsFalse() {
        TeamPaginationManager.shared.friendsPaginating = true
        XCTAssertEqual(TeamPaginationManager.shared.shouldPaginateFriends(), false)
    }

    func testShouldPaginateFriendsTrue() {
        TeamPaginationManager.shared.friendsPaginationComplete()

        let previousPage = TeamPaginationManager.shared.friendsPageIndex
        XCTAssertEqual(TeamPaginationManager.shared.shouldPaginateFriends(), true)
        XCTAssertEqual(TeamPaginationManager.shared.friendsPageIndex, previousPage + 1)
    }

    func testShouldPaginateFriendsWithIndexPathFalse() {
        var friends:[MyTeamFriends] = []
        var indexPath = IndexPath(row: 0, section: 0)
        var result = TeamPaginationManager.shared.shouldPaginateFriends(indexPath: indexPath, friends: friends)
        XCTAssertEqual(result, false)

        friends = [MyTeamFriends()]
        indexPath = IndexPath(row: 1, section: 0)
        result = TeamPaginationManager.shared.shouldPaginateFriends(indexPath: indexPath, friends: friends)
        XCTAssertEqual(result, true)
    }

    func testReset() {
        TeamPaginationManager.shared.reset()

        XCTAssertEqual(TeamPaginationManager.shared.friendsPageIndex, 0)
        XCTAssertEqual(TeamPaginationManager.shared.friendsPaginating, false)
        XCTAssertEqual(TeamPaginationManager.shared.pendingFriendsPageIndex, 0)
        XCTAssertEqual(TeamPaginationManager.shared.pendingFriendsPaginating, false)
    }
}
