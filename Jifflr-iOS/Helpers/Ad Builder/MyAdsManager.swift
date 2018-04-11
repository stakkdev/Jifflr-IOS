//
//  MyAdsManager.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 11/04/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit
import Parse

class MyAdsManager: NSObject {
    static let shared = MyAdsManager()
    
    let pinName = AdBuilderManager.shared.pinName
    
    func fetchData(completion: @escaping (MyAds?) -> Void) {
        let group = DispatchGroup()
        let myAds = MyAds()
        
        group.enter()
        self.fetchUserAds { (adverts) in
            myAds.adverts = adverts
            group.leave()
        }
        
        group.enter()
        self.countActiveUserAds { (count) in
            guard let count = count else {
                completion(nil)
                return
            }
            
            myAds.activeAds = count
            group.leave()
        }
        
        group.enter()
        self.fetchChartData { (points) in
            guard let graph = points else {
                completion(nil)
                return
            }
            
            myAds.graph = graph
            group.leave()
        }
        
        group.notify(queue: .main) {
            PFObject.unpinAllObjectsInBackground(withName: self.pinName, block: { (success, error) in
                myAds.pinInBackground(withName: self.pinName, block: { (success, error) in
                    print("My Ads Pinned: \(success)")
                })
            })
            
            completion(myAds)
        }
    }
    
    func fetchUserAds(completion: @escaping ([Advert]) -> Void) {
        guard let currentUser = Session.shared.currentUser else { return }
        
        let query = Advert.query()
        query?.whereKey("creator", equalTo: currentUser)
        query?.includeKey("details")
        query?.includeKey("status")
        query?.findObjectsInBackground(block: { (objects, error) in
            guard let ads = objects as? [Advert], error == nil else {
                completion([])
                return
            }
            
            completion(ads)
        })
    }
    
    func countActiveUserAds(completion: @escaping (Int?) -> Void) {
        guard let currentUser = Session.shared.currentUser else { return }
        
        let query = Advert.query()
        query?.whereKey("creator", equalTo: currentUser)
        query?.includeKey("status")
        query?.findObjectsInBackground(block: { (objects, error) in
            guard let ads = objects as? [Advert], error == nil else {
                completion(nil)
                return
            }
            
            var count = 0
            for ad in ads {
                if ad.status?.key == AdvertStatusKey.availableActive {
                    count += 1
                }
            }
            
            completion(count)
        })
    }
    
    func fetchChartData(completion: @escaping ([BarChartPoint]?) -> Void) {
//        guard let user = Session.shared.currentUser else { return }
//
//        PFCloud.callFunction(inBackground: "campaign-chart", withParameters: ["user": user.objectId!]) { myAdsJSON, error in
//            if let myAdsJSON = myAdsJSON as? [String: Any] {
//                if let points = myAdsJSON["graph"] as? [[Any]] {
                    var graph:[BarChartPoint] = []
                    
                    let points = [["J", 20.0], ["F", 4.0], ["M", 16.0], ["A", 1.0], ["M", 3.0], ["J", 7.0], ["J", 9.0], ["A", 10.0], ["S", 21.0], ["O", 2.0], ["N", 4.0], ["D", 8.0]]
                    
                    for point in points {
                        guard let month = point.first as? String, let value = point.last as? Double else { continue }
                        
                        let graphPoint = BarChartPoint()
                        graphPoint.x = month
                        graphPoint.y = value
                        graph.append(graphPoint)
                    }
                    
                    completion(graph)
//                }
//
//                completion(nil)
//            } else {
//                completion(nil)
//            }
//        }
    }
    
    func fetchLocalData(completion: @escaping (MyAds?) -> Void) {
        let query = MyAds.query()
        query?.includeKey("adverts")
        query?.order(byDescending: "createdAt")
        query?.fromPin(withName: self.pinName)
        query?.getFirstObjectInBackground(block: { (object, error) in
            guard let myAds = object as? MyAds, error == nil else {
                completion(nil)
                return
            }
            
            completion(myAds)
        })
    }
}
