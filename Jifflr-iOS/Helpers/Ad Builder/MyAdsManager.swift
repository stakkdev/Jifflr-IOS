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
    
    let pinName = AdvertManager.shared.pinName
    
    func fetchMyAds() {
        guard let currentUser = Session.shared.currentUser else { return }
        
        let query = Advert.query()
        query?.whereKey("creator", equalTo: currentUser)
        query?.whereKey("isCMS", equalTo: true)
        query?.includeKey("questions")
        query?.includeKey("questions.answers")
        query?.includeKey("questions.type")
        query?.includeKey("details")
        query?.includeKey("details.template")
        query?.findObjectsInBackground(block: { (adverts, error) in
            guard let adverts = adverts as? [Advert], error == nil else {
                return
            }
            
            PFObject.pinAll(inBackground: adverts, withName: self.pinName, block: { (success, error) in
                let group = DispatchGroup()
                
                for advert in adverts {
                    group.enter()
                    PFObject.pinAll(inBackground: advert.questions, withName: self.pinName, block: { (success, error) in
                        group.leave()
                    })
                    
                    for question in advert.questions {
                        group.enter()
                        PFObject.pinAll(inBackground: question.answers, withName: self.pinName, block: { (success, error) in
                            group.leave()
                        })
                        
                        group.enter()
                        question.type.pinInBackground(withName: self.pinName, block: { (success, error) in
                            group.leave()
                        })
                    }
                    
                    if let details = advert.details {
                        group.enter()
                        details.pinInBackground(withName: self.pinName, block: { (success, error) in
                            group.leave()
                        })
                        
                        group.enter()
                        details.template?.pinInBackground(withName: self.pinName, block: { (success, error) in
                            group.leave()
                        })
                        
                        group.enter()
                        details.image?.getDataInBackground(block: { (data, error) in
                            if let data = data, error == nil {
                                let fileExtension = UIImage(data: data) != nil ? "jpg" : "mp4"
                                let success = MediaManager.shared.save(data: data, id: details.objectId, fileExtension: fileExtension)
                                print("MyAds Media: \(details.objectId ?? "") saved to File Manager: \(success)")
                            }
                            
                            group.leave()
                        })
                    }
                }
                
                group.notify(queue: .main, execute: {
                    print("Fetched My Ads from Server")
                })
            })
        })
    }
    
    func fetchData(completion: @escaping (MyAds?) -> Void) {
        let group = DispatchGroup()
        let myAds = MyAds()
        var returnCount = 0

        self.fetchUserAds { (adverts) in
            myAds.adverts = adverts

            group.enter()
            self.countActiveUserAds { (count) in
                DispatchQueue.main.async {
                    if let count = count {
                        myAds.activeAds = count
                        returnCount += 1
                    }
                    group.leave()
                }
            }

            group.enter()
            self.fetchChartData { (points) in
                if let graph = points {
                    myAds.graph = graph
                    returnCount += 1
                }
                group.leave()
            }
            
            group.enter()
            CampaignManager.shared.fetchCampaigns(completion: { (campaigns) in
                DispatchQueue.main.async {
                    if let campaigns = campaigns {
                        myAds.campaigns = campaigns
                        returnCount += 1
                    }
                    group.leave()
                }
            })
            
            group.enter()
            CampaignManager.shared.countCampaigns(completion: { (count) in
                DispatchQueue.main.async {
                    if let count = count {
                        myAds.campaignCount = count
                        returnCount += 1
                    }
                    group.leave()
                }
            })

            group.notify(queue: .main) {
                guard returnCount == 4 else {
                    completion(nil)
                    return
                }
                
                self.unpinAllMyAds {
                    myAds.pinInBackground(withName: self.pinName, block: { (success, error) in
                        print("My Ads Pinned: \(success)")
                    })
                }

                completion(myAds)
            }
        }
    }
    
    func unpinAllMyAds(completion: @escaping () -> Void) {
        let query = MyAds.query()
        query?.fromPin(withName: self.pinName)
        query?.findObjectsInBackground(block: { (objects, error) in
            guard let objects = objects, error == nil else {
                completion()
                return
            }
            
            PFObject.unpinAll(inBackground: objects, withName: self.pinName, block: { (success, error) in
                completion()
            })
        })
    }
    
    func unpinAllBarChartPoints(completion: @escaping () -> Void) {
        let query = BarChartPoint.query()
        query?.fromPin(withName: self.pinName)
        query?.findObjectsInBackground(block: { (objects, error) in
            guard let objects = objects, error == nil else {
                completion()
                return
            }
            
            PFObject.unpinAll(inBackground: objects, withName: self.pinName, block: { (success, error) in
                completion()
            })
        })
    }
    
    func fetchUserAds(completion: @escaping ([Advert]) -> Void) {
        guard let currentUser = Session.shared.currentUser else { return }
        
        let query = Advert.query()
        query?.whereKey("creator", equalTo: currentUser)
        query?.order(byDescending: "createdAt")
        query?.includeKey("details")
        query?.includeKey("details.template")
        query?.includeKey("questions")
        query?.includeKey("questions.type")
        query?.fromPin(withName: self.pinName)
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

        let query = Campaign.query()
        query?.whereKey("creator", equalTo: currentUser)
        query?.includeKey("advert")
        query?.fromPin(withName: self.pinName)
        query?.findObjectsInBackground(block: { (objects, error) in
            guard let campaigns = objects as? [Campaign], error == nil else {
                completion(nil)
                return
            }
            
            var ads:[String] = []
            for campaign in campaigns {
                guard campaign.status == CampaignStatusKey.availableActive else { continue }
                guard !ads.contains(campaign.advert.objectId!) else { continue }
                ads.append(campaign.advert.objectId!)
            }

            completion(ads.count)
        })
    }
    
    func fetchChartData(completion: @escaping ([BarChartPoint]?) -> Void) {
        guard let user = Session.shared.currentUser else { return }

        PFCloud.callFunction(inBackground: "campaign-chart", withParameters: ["user": user.objectId!]) { myAdsJSON, error in
            if let points = myAdsJSON as? [[Any]] {
                var graph:[BarChartPoint] = []
                
                for point in points {
                    guard let month = point.first as? String, let value = point.last as? Double else { continue }
                    
                    let graphPoint = BarChartPoint()
                    graphPoint.x = month
                    graphPoint.y = value
                    graph.append(graphPoint)
                }
    
                self.unpinAllBarChartPoints {
                    PFObject.pinAll(inBackground: graph, withName: self.pinName) { (success, error) in
                        print("Chart Pinned: \(success)")
                    }
                    
                    completion(graph)
                }
            } else {
                completion(nil)
            }
        }
    }
    
    func fetchLocalData(completion: @escaping (MyAds?) -> Void) {
        let query = MyAds.query()
        query?.includeKey("adverts")
        query?.includeKey("adverts.details")
        query?.includeKey("adverts.details.template")
        query?.includeKey("adverts.status")
        query?.includeKey("graph")
        query?.includeKey("campaign")
        query?.includeKey("campaign.status")
        query?.includeKey("campaign.demographic")
        query?.includeKey("campaign.demographic.location")
        query?.includeKey("campaign.demographic.language")
        query?.includeKey("campaign.demographic.gender")
        query?.includeKey("campaign.schedule")
        query?.includeKey("campaign.locationFinancial")
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
