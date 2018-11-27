//
//  AdsViewedManager.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 22/02/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit
import Parse

class AdsViewedManager: NSObject {
    static let shared = AdsViewedManager()
    let pinName = "AdsViewed"

    func fetch(completion: @escaping (AdsViewed?, ErrorMessage?) -> Void) {
        guard let user = Session.shared.currentUser else { return }

        PFCloud.callFunction(inBackground: "ads-view-overview", withParameters: ["user": user.objectId!]) { adsViewedJSON, error in
            if let adsViewedJSON = adsViewedJSON as? [String: Any] {
                let adsViewed = AdsViewed()

                if let points = adsViewedJSON["graph"] as? [[Double]] {
                    var graph:[Graph] = []
                    for point in points {
                        guard point.count == 2 else { continue }
                        
                        let graphPoint = Graph()
                        graphPoint.x = point.first!
                        graphPoint.y = point.last!
                        graph.append(graphPoint)
                    }
                    
                    adsViewed.graph = graph
                }

                if let points = adsViewedJSON["graphTarget"] as? [[Double]] {
                    var graph:[Graph] = []
                    for point in points {
                        guard point.count == 2 else { continue }
                        
                        let graphPoint = Graph()
                        graphPoint.x = point.first!
                        graphPoint.y = point.last!
                        graph.append(graphPoint)
                    }
                    
                    adsViewed.targetGraph = graph
                }

                if let viewed = adsViewedJSON["adsViewed"] as? Int {
                    adsViewed.viewed = viewed
                }

                if let adsPerDay = adsViewedJSON["adsPerDay"] as? Int {
                    adsViewed.adsPerDay = adsPerDay
                }

                if let adBacklog = adsViewedJSON["adBacklog"] as? Int {
                    adsViewed.adBacklog = adBacklog
                }

                if let adBacklogThreshold = adsViewedJSON["adBacklogThreshold"] as? Int {
                    adsViewed.adBacklogThreshold = adBacklogThreshold
                }

                if let teamIncomeDuePercentage = adsViewedJSON["teamIncomeDuePercentage"] as? Int {
                    adsViewed.teamIncomeDuePercentage = teamIncomeDuePercentage
                }

                if let history = adsViewedJSON["history"] as? [UserMonthStats] {
                    let orderedHistory = history.sorted(by: {$0.createdAt! > $1.createdAt! })
                    adsViewed.history = orderedHistory
                }

                PFObject.unpinAllObjectsInBackground(withName: self.pinName, block: { (success, error) in
                    adsViewed.pinInBackground(withName: self.pinName, block: { (success, error) in
                        print("AdsViewed Pinned: \(success)")

                        if let error = error {
                            print("Error: \(error)")
                        }
                    })
                })

                completion(adsViewed, nil)
            } else {
                completion(nil, ErrorMessage.unknown)
            }
        }
    }

    func fetchLocal(completion: @escaping (AdsViewed?, ErrorMessage?) -> Void) {
        let query = AdsViewed.query()
        query?.includeKey("graph")
        query?.includeKey("targetGraph")
        query?.includeKey("history")
        query?.order(byDescending: "createdAt")
        query?.fromPin(withName: self.pinName)
        query?.getFirstObjectInBackground(block: { (adsViewed, error) in
            guard let adsViewed = adsViewed as? AdsViewed, error == nil else {
                completion(nil, ErrorMessage.unknown)
                return
            }

            completion(adsViewed, nil)
        })
    }
}
