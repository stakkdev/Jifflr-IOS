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

                if let graph = myTeamJSON["graph"] as? [(x: Double, y: Double)] {
                    myTeam.graph = graph
                }

                if let teamSize = myTeamJSON["teamSize"] as? Int {
                    myTeam.teamSize = teamSize
                }

                if let friends = myTeamJSON["friends"] as? [(user: PFUser, teamSize: Int)] {
                    myTeam.friends = friends
                }

                if let pendingFriends = myTeamJSON["pendingFriends"] as? [(user: PFUser, isActive: Bool)] {
                    myTeam.pendingFriends = pendingFriends
                }

                myTeam.pinInBackground(withName: self.pinName, block: { (success, error) in
                    print("MyTeam Pinned: \(success)")

                    if let error = error {
                        print("Error: \(error)")
                    }
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
