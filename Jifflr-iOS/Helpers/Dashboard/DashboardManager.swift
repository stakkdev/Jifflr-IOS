//
//  DashboardManager.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 21/02/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit
import Parse

class DashboardManager: NSObject {
    static let shared = DashboardManager()

    let pinName = "DashboardStats"

    func fetchStats(completion: @escaping (DashboardStats?, ErrorMessage?) -> Void) {
        guard let user = Session.shared.currentUser else { return }

        PFCloud.callFunction(inBackground: "dashboard-onview", withParameters: ["user": user.objectId!]) { dashboardJSON, error in
            if let dashboardJSON = dashboardJSON as? [String: Any] {
                let dashboardStats = DashboardStats()

                if let teamSize = dashboardJSON["teamSize"] as? Int {
                    dashboardStats.teamSize = teamSize
                }

                if let adsViewed = dashboardJSON["adsViewed"] as? Int {
                    dashboardStats.adsViewed = adsViewed
                }

                if let money = dashboardJSON["money"] as? Double {
                    dashboardStats.money = money
                }

                if let adsCreated = dashboardJSON["adsCreated"] as? Int {
                    dashboardStats.adsCreated = adsCreated
                }

                PFObject.unpinAllObjectsInBackground(withName: self.pinName, block: { (success, error) in
                    dashboardStats.pinInBackground(withName: self.pinName, block: { (success, error) in
                        print("DashboardStats Pinned: \(success)")

                        if let error = error {
                            print("Error: \(error)")
                        }
                    })
                })

                completion(dashboardStats, nil)
            } else {
                completion(nil, ErrorMessage.unknown)
            }
        }
    }

    func fetchLocalStats(completion: @escaping (DashboardStats?, ErrorMessage?) -> Void) {
        let query = DashboardStats.query()
        query?.order(byDescending: "createdAt")
        query?.fromPin(withName: self.pinName)
        query?.getFirstObjectInBackground(block: { (stats, error) in
            guard let stats = stats as? DashboardStats, error == nil else {
                completion(nil, ErrorMessage.noInternetConnection)
                return
            }

            completion(stats, nil)
        })
    }
}
