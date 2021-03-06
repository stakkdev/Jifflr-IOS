//
//  AdvertManager.swift
//  Ad-M8-iOS
//
//  Created by James Shaw on 12/10/2017.
//  Copyright © 2017 The Distance. All rights reserved.
//

import UIKit
import Parse

class AdvertManager: NSObject {
    static let shared = AdvertManager()
    
    var userSeenAdExchangeToSave: [UserSeenAdExchange] = []

    let pinName = "Ads"

    func fetch(completion: @escaping () -> Void) {
        guard let user = Session.shared.currentUser else { return }

        self.countLocal { (count) in
            guard self.shouldFetch(count: count) else {
                completion()
                return
            }

            PFCloud.callFunction(inBackground: "fetch-campaigns", withParameters: ["user": user.objectId!]) { responseJSON, error in
                if let responseJSON = responseJSON as? [String: Any], error == nil {
                    
                    guard let totalAdsWatched = responseJSON["totalAdsWatched"] as? Int else {
                        completion()
                        return
                    }
                    
                    AppSettingsManager.shared.canViewAds(currentCount: totalAdsWatched, completion: { (canViewAds) in
                        guard canViewAds else {
                            completion()
                            return
                        }
                        
                        var campaigns:[Campaign] = []
                        if let cmsAds = responseJSON["cmsAds"] as? [Campaign] {
                            campaigns += cmsAds
                        }
                        
                        PFObject.pinAll(inBackground: campaigns, withName: self.pinName, block: { (success, error) in
                            let group = DispatchGroup()
                            
                            for campaign in campaigns {
                                group.enter()
                                campaign.advert.pinInBackground(withName: self.pinName, block: { (success, error) in
                                    group.leave()
                                })
                                
                                group.enter()
                                campaign.schedule?.pinInBackground(withName: self.pinName, block: { (success, error) in
                                    group.leave()
                                })
                                
                                group.enter()
                                PFObject.pinAll(inBackground: campaign.advert.questions, withName: self.pinName, block: { (success, error) in
                                    group.leave()
                                })
                                
                                for question in campaign.advert.questions {
                                    group.enter()
                                    PFObject.pinAll(inBackground: question.answers, withName: self.pinName, block: { (success, error) in
                                        group.leave()
                                    })
                                    
                                    group.enter()
                                    question.type.pinInBackground(withName: self.pinName, block: { (success, error) in
                                        group.leave()
                                    })
                                }
                                
                                if let details = campaign.advert.details {
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
                                            print("Ads Media: \(details.objectId ?? "") saved to File Manager: \(success)")
                                        }
                                        
                                        group.leave()
                                    })
                                }
                            }
                            
                            group.notify(queue: .main, execute: {
                                completion()
                            })
                        })
                    })
                } else {
                    completion()
                }
            }
        }
    }

    func countLocal(completion: @escaping (Int) -> Void) {
        guard let user = Session.shared.currentUser else { return }
        
        let query = Campaign.query()
        query?.fromPin(withName: self.pinName)
        query?.whereKey("creator", notEqualTo: user)
        query?.countObjectsInBackground(block: { (count, error) in
            guard error == nil else {
                completion(0)
                return
            }

            completion(Int(count))
        })
    }

    func fetchNextLocal(completion: @escaping (Any?) -> Void) {
        guard let user = Session.shared.currentUser else { return }
        
        let query = Campaign.query()
        query?.fromPin(withName: self.pinName)
        query?.whereKey("creator", notEqualTo: user)
        query?.includeKey("advert.questions")
        query?.includeKey("advert.questions.answers")
        query?.includeKey("advert.questions.type")
        query?.includeKey("advert.details")
        query?.includeKey("advert.details.template")
        query?.includeKey("schedule")
        query?.getFirstObjectInBackground(block: { (object, error) in
            if let campaign = object as? Campaign, error == nil {
                if self.validDate(campaign: campaign) && self.campaignHasMedia(objectId: campaign.advert.details?.objectId) {
                    completion(campaign)
                } else {
                    self.unpin(campaign: campaign) {
                        self.fetchNextLocal { (newObject) in
                            completion(newObject)
                        }
                    }
                }
                return
            } else {
                self.fetchDefaultAdExchange(completion: { (advert) in
                    completion(advert)
                    return
                })
            }
        })
    }
    
    func campaignHasMedia(objectId: String?) -> Bool {
        let imageURL = MediaManager.shared.get(id: objectId, fileExtension: "jpg")
        let videoURL = MediaManager.shared.get(id: objectId, fileExtension: "mp4")
        
        return videoURL != nil || imageURL != nil
    }
    
    func validDate(campaign: Campaign) -> Bool {
        guard let schedule = campaign.schedule else { return true }
        
        var calendar = Calendar.current
        calendar.locale = Locale.current
        calendar.timeZone = TimeZone(identifier: "UTC")!
        var startTimeComponents = calendar.dateComponents([.hour, .minute, .second], from: schedule.startDate)
        var endTimeComponents = calendar.dateComponents([.hour, .minute, .second], from: schedule.endDate)
        
        startTimeComponents.timeZone = TimeZone(identifier: "UTC")!
        startTimeComponents.calendar = calendar
        endTimeComponents.timeZone = TimeZone(identifier: "UTC")!
        endTimeComponents.calendar = calendar
        
        guard let startDate = calendar.date(from: startTimeComponents) else { return false }
        guard let endDate = calendar.date(from: endTimeComponents) else { return false }
        
        calendar.timeZone = TimeZone.current
        var currentTimeComponents = calendar.dateComponents([.hour, .minute, .second], from: Date())
        currentTimeComponents.timeZone = TimeZone.current
        currentTimeComponents.calendar = calendar
        guard let currentDate = calendar.date(from: currentTimeComponents) else { return false }
        
        return currentDate >= startDate && currentDate <= endDate
    }

    func fetchAdExchange(local: Bool, completion: @escaping (Advert?) -> Void) {
        let query = Advert.query()
        if local { query?.fromLocalDatastore() }
        query?.whereKey("isCMS", equalTo: false)
        query?.getFirstObjectInBackground(block: { (object, error) in
            guard let advert = object as? Advert, error == nil else {
                completion(nil)
                return
            }

            completion(advert)
        })
    }
    
    func fetchDefaultAdExchange(completion: @escaping (Advert?) -> Void) {
        self.fetchAdExchange(local: true) { (advert) in
            if let advert = advert {
                completion(advert)
                return
            } else {
                guard Reachability.isConnectedToNetwork() else {
                    completion(nil)
                    return
                }
                
                self.fetchAdExchange(local: false, completion: { (advert) in
                    advert?.pinInBackground(block: { (success, error) in
                        print("Ad Exchange Ad Pinned: \(success)")
                        completion(advert)
                        return
                    })
                })
            }
        }
    }

    func fetchSwipeQuestion(completion: @escaping (AdExchangeQuestion?) -> Void) {
        
        PFCloud.callFunction(inBackground: "next-exchange-question", withParameters: nil) { (JSONResponse, error) in
            guard let adExchangeQuestion = JSONResponse as? AdExchangeQuestion, error == nil else {
                completion(nil)
                return
            }
            
            completion(adExchangeQuestion)
        }
    }

    func shouldFetch(count: Int) -> Bool {
        if count >= 20 {
            return false
        }

        return true
    }
    
    func flag(campaign: Campaign, moderatorFeedbackCategory: ModeratorFeedbackCategory) {
        guard let user = Session.shared.currentUser else { return }
        
        self.unpin(campaign: campaign) {
            let userFlaggedCampaign = UserFlaggedCampaign()
            userFlaggedCampaign.user = user
            userFlaggedCampaign.campaign = campaign
            userFlaggedCampaign.category = moderatorFeedbackCategory
            userFlaggedCampaign.saveEventually()
        }
    }
    
    func unpin(campaign: Campaign, completion: @escaping () -> Void) {
        PFObject.unpinAll(inBackground: campaign.advert.questions, withName: self.pinName) { (success, error) in
            campaign.advert.details?.unpinInBackground(withName: self.pinName, block: { (success, error) in
                campaign.advert.unpinInBackground(withName: self.pinName, block: { (success, error) in
                    campaign.unpinInBackground(withName: self.pinName, block: { (success, error) in
                        completion()
                    })
                })
            })
        }
    }
}
