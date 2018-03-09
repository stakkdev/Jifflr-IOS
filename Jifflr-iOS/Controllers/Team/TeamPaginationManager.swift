//
//  TeamPaginationManager.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 24/02/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit

class TeamPaginationManager: NSObject {
    static let shared = TeamPaginationManager()

    var friendsPageIndex = 0
    var friendsPaginating = false
    var friendsCountPrevious = 0
    var pendingFriendsPageIndex = 0
    var pendingFriendsPaginating = false
    var pendingFriendsCountPrevious = 0

    func reset() {
        self.friendsPageIndex = 0
        self.friendsPaginating = false
        self.friendsCountPrevious = 0
        self.pendingFriendsPageIndex = 0
        self.pendingFriendsPaginating = false
        self.pendingFriendsCountPrevious = 0
    }

    func shouldPaginateFriends() -> Bool {
        guard self.friendsPaginating == false else { return false }
        self.friendsPaginating = true
        self.friendsPageIndex += 1

        return true
    }

    func shouldPaginateFriends(indexPath: IndexPath, friends: [MyTeamFriends]) -> Bool {
        if indexPath.row == friends.count && friends.count != 0 && self.friendsCountPrevious != friends.count {
            self.friendsCountPrevious = friends.count
            return true
        }

        return false
    }

    func friendsPaginationComplete() {
        self.friendsPaginating = false
    }

    func shouldPaginatePendingFriends() -> Bool {
        guard self.pendingFriendsPaginating == false else { return false }
        self.pendingFriendsPaginating = true

        self.pendingFriendsPageIndex += 1

        return true
    }

    func shouldPaginatePendingFriends(indexPath: IndexPath, pendingFriends: [PendingUser]) -> Bool {
        if indexPath.row == pendingFriends.count - 1 && self.pendingFriendsCountPrevious != pendingFriends.count {
            self.pendingFriendsCountPrevious = pendingFriends.count
            return true
        }

        return false
    }

    func pendingFriendsPaginationComplete() {
        self.pendingFriendsPaginating = false
    }
}
