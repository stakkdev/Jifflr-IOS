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

    func fetchStats(completion: @escaping (MyTeam?, ErrorMessage?) -> Void) {
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

                PFObject.unpinAllObjectsInBackground(withName: self.pinName, block: { (success, error) in
                    myTeam.pinInBackground(withName: self.pinName, block: { (success, error) in
                        print("MyTeam Stats Pinned: \(success)")

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

    func fetchFriends(page: Int, completion: @escaping ([MyTeamFriends]?, ErrorMessage?) -> Void) {
        guard let user = Session.shared.currentUser else { return }
        
        let parameters = ["user": user.objectId!, "limit": 20, "page": page] as [String : Any]
        PFCloud.callFunction(inBackground: "my-team-friends", withParameters: parameters) { myTeamJSON, error in
            if let myTeamJSON = myTeamJSON as? [String: Any] {

                if let friendsArray = myTeamJSON["friends"] as? [(user: PFUser, teamSize: Int, date: Date)] {
                    var friends:[MyTeamFriends] = []
                    for friendsTuple in friendsArray {
                        let friend = MyTeamFriends()
                        friend.user = friendsTuple.user
                        friend.teamSize = friendsTuple.teamSize
                        friend.date = friendsTuple.date
                        friends.append(friend)
                    }

                    PFObject.pinAll(inBackground: friends, withName: self.pinName, block: { (success, error) in
                        print("MyTeam Friends Pinned: \(success)")

                        if let error = error {
                            print("Error: \(error)")
                        }
                    })

                    completion(friends, nil)
                } else {
                    completion(nil, ErrorMessage.unknown)
                }
            } else {
                if let error = error {
                    completion(nil, ErrorMessage.parseError(error.localizedDescription))
                } else {
                    completion(nil, ErrorMessage.unknown)
                }
            }
        }
    }

    func fetchPendingFriends(page: Int, completion: @escaping ([PendingUser]?, ErrorMessage?) -> Void) {
        guard let user = Session.shared.currentUser else { return }

        let parameters = ["user": user.objectId!, "limit": 20, "page": page] as [String : Any]
        PFCloud.callFunction(inBackground: "my-team-pending-friends", withParameters: parameters) { myTeamJSON, error in
            if let pendingFriends = myTeamJSON as? [PendingUser] {
                PFObject.pinAll(inBackground: pendingFriends, withName: self.pinName, block: { (success, error) in
                    print("MyTeam Pending Friends Pinned: \(success)")

                    if let error = error {
                        print("Error: \(error)")
                    }
                })

                completion(pendingFriends, nil)
            } else {
                if let error = error {
                    completion(nil, ErrorMessage.parseError(error.localizedDescription))
                } else {
                    completion(nil, ErrorMessage.unknown)
                }
            }
        }
    }

    func fetchLocalStats(completion: @escaping (MyTeam?, ErrorMessage?) -> Void) {
        let query = MyTeam.query()
        query?.includeKey("graph")
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

    func fetchLocalFriends(page: Int, completion: @escaping ([MyTeamFriends]?, ErrorMessage?) -> Void) {
        let query = MyTeamFriends.query()
        query?.includeKey("user")
        query?.includeKey("user.details")
        query?.order(byDescending: "createdAt")
        query?.fromPin(withName: self.pinName)
        query?.limit = 20
        query?.skip = 20 * page
        query?.findObjectsInBackground(block: { (friends, error) in
            guard let friends = friends as? [MyTeamFriends], error == nil else {
                completion(nil, ErrorMessage.unknown)
                return
            }

            completion(friends, nil)
        })
    }

    func fetchLocalPendingFriends(page: Int, completion: @escaping ([PendingUser]?, ErrorMessage?) -> Void) {
        let query = PendingUser.query()
        query?.includeKey("sender")
        query?.order(byDescending: "createdAt")
        query?.fromPin(withName: self.pinName)
        query?.limit = 20
        query?.skip = 20 * page
        query?.findObjectsInBackground(block: { (pendingFriends, error) in
            guard let pendingFriends = pendingFriends as? [PendingUser], error == nil else {
                completion(nil, ErrorMessage.unknown)
                return
            }

            completion(pendingFriends, nil)
        })
    }
}
