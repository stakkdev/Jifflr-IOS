//
//  MyTeamManager.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 16/02/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit
import Parse

class MyTeamManager: NSObject {
    static let shared = MyTeamManager()
    let pinName = "MyTeam"

    func fetch(completion: @escaping (MyTeam?, ErrorMessage?) -> Void) {
        guard let user = Session.shared.currentUser else { return }

        PFCloud.callFunction(inBackground: "my-team-overview", withParameters: ["user": user.objectId!]) { myTeamJSON, error in
            if let myTeamJSON = myTeamJSON as? [String: Any] {
                let myTeam = MyTeam()

                if let points = myTeamJSON["graph"] as? [(x: Double, y: Double)] {
                    var graph:[Graph] = []
                    for point in points {
                        let graphPoint = Graph()
                        graphPoint.x = point.x
                        graphPoint.y = point.y
                        graph.append(graphPoint)
                    }

                    myTeam.graph = graph
                }

                if let teamSize = myTeamJSON["teamSize"] as? Int {
                    myTeam.teamSize = teamSize
                }

                if let friendsArray = myTeamJSON["friends"] as? [(user: PFUser, teamSize: Int)] {
                    var friends:[MyTeamFriends] = []
                    for friendsTuple in friendsArray {
                        let friend = MyTeamFriends()
                        friend.user = friendsTuple.user
                        friend.teamSize = friendsTuple.teamSize
                        friends.append(friend)
                    }

                    myTeam.friends = friends
                }

                if let pendingFriendsArray = myTeamJSON["pendingFriends"] as? [(user: PendingUser, isActive: Bool)] {
                    var pendingFriends:[MyTeamPendingFriends] = []
                    for pendingFriendsTuple in pendingFriendsArray {
                        let pendingFriend = MyTeamPendingFriends()
                        pendingFriend.pendingUser = pendingFriendsTuple.user
                        pendingFriend.isActive = pendingFriendsTuple.isActive
                        pendingFriends.append(pendingFriend)
                    }

                    myTeam.pendingFriends = pendingFriends
                }

                PFObject.unpinAllObjectsInBackground(withName: self.pinName, block: { (success, error) in
                    myTeam.pinInBackground(withName: self.pinName, block: { (success, error) in
                        print("MyTeam Pinned: \(success)")

                        if let error = error {
                            print("Error: \(error)")
                        }
                    })
                })

                completion(myTeam, nil)
            } else {
                if let error = error {
                    completion(nil, ErrorMessage.parseError(error.localizedDescription))
                } else {
                    completion(nil, ErrorMessage.unknown)
                }
            }
        }
    }

    func fetchLocal(completion: @escaping (MyTeam?, ErrorMessage?) -> Void) {
        let query = MyTeam.query()
        query?.includeKey("graph")
        query?.includeKey("friends")
        query?.includeKey("pendingFriends")
        query?.order(byDescending: "createdAt")
        query?.fromPin(withName: self.pinName)
        query?.getFirstObjectInBackground(block: { (myTeam, error) in
            guard let myTeam = myTeam as? MyTeam, error == nil else {
                completion(nil, ErrorMessage.unknown)
                return
            }

            completion(myTeam, nil)
        })
    }
}
