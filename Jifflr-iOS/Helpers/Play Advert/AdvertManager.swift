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

    let pinName = "Ads"

    func fetch(completion: @escaping () -> Void) {
        guard let user = Session.shared.currentUser else { return }

        self.countLocal { (count) in
            guard self.shouldFetch(count: count) else {
                completion()
                return
            }

//            PFCloud.callFunction(inBackground: "fetch-campaigns", withParameters: ["user": user.objectId!]) { responseJSON, error in
//                if let responseJSON = responseJSON as? [String: Any], error == nil {
//
//                    var adverts:[Advert] = []
//                    if let advert = responseJSON["defaultAd"] as? Advert {
//                        adverts.append(advert)
//                    }
//
//                    if let cmsAds = responseJSON["cmsAds"] as? [Advert] {
//                        adverts += cmsAds
//                    }
//
//                    PFObject.pinAll(inBackground: adverts, withName: self.pinName, block: { (success, error) in
//                        if success == true, error == nil {
//                            print("\(adverts.count) adverts pinned.")
//                        }
//
//                        completion()
//                    })
//                } else {
//                    completion()
//                }
//            }
            
            let query = Campaign.query()
            query?.whereKey("creator", notEqualTo: user)
            query?.includeKey("advert")
            query?.includeKey("advert.questions")
            query?.includeKey("advert.questions.answers")
            query?.includeKey("advert.questions.type")
            query?.includeKey("advert.details")
            query?.includeKey("advert.details.template")
            query?.findObjectsInBackground(block: { (campaigns, error) in
                guard let campaigns = campaigns as? [Campaign], error == nil else {
                    completion()
                    return
                }
                
                PFObject.pinAll(inBackground: campaigns, withName: self.pinName, block: { (success, error) in
                    let group = DispatchGroup()
                    
                    for campaign in campaigns {
                        group.enter()
                        campaign.advert.pinInBackground(withName: self.pinName, block: { (success, error) in
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
        query?.getFirstObjectInBackground(block: { (object, error) in
            if let campaign = object as? Campaign, error == nil {
                completion(campaign)
                return
            } else {
                self.fetchDefaultAdExchange(completion: { (advert) in
                    completion(advert)
                    return
                })
            }
        })
    }

    func fetchAdExchange(local: Bool, completion: @escaping (Advert?) -> Void) {
        let query = Advert.query()
        if local { query?.fromPin(withName: self.pinName) }
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

    func fetchSwipeQuestions(completion: @escaping ([Question]) -> Void) {

        self.fetchSwipeQuestionType { (questionType) in
            guard let questionType = questionType else {
                completion([])
                return
            }

            let countQuery = Question.query()
            countQuery?.limit = 10000
            countQuery?.whereKey("type", equalTo: questionType)
            countQuery?.whereKey("active", equalTo: true)
            countQuery?.countObjectsInBackground(block: { (count, error) in
                guard error == nil, count > 0 else {
                    completion([])
                    return
                }

                let randomIndex = Int(arc4random_uniform(UInt32(count - 3)))
                let query = Question.query()
                query?.limit = 3
                query?.skip = randomIndex
                query?.whereKey("type", equalTo: questionType)
                query?.whereKey("active", equalTo: true)
                query?.includeKey("type")
                query?.includeKey("answers")
                query?.findObjectsInBackground(block: { (objects, error) in
                    guard let questions = objects as? [Question], error == nil else {
                        completion([])
                        return
                    }

                    completion(questions)
                })
            })

        }
    }

    func fetchSwipeQuestionType(completion: @escaping (QuestionType?) -> Void) {
        let query = QuestionType.query()
        query?.whereKey("type", equalTo: AdvertQuestionType.Swipe)
        query?.getFirstObjectInBackground(block: { (object, error) in
            guard let questionType = object as? QuestionType, error == nil else {
                completion(nil)
                return
            }

            completion(questionType)
        })
    }

    func shouldFetch(count: Int) -> Bool {
        if count >= 20 {
            return false
        }

        return true
    }
    
    func flag(advert: Advert, moderatorFeedbackCategory: ModeratorFeedbackCategory) {
        guard let user = Session.shared.currentUser else { return }
        
        let userFlaggedAd = UserFlaggedAd()
        userFlaggedAd.user = user
        userFlaggedAd.advert = advert
        userFlaggedAd.category = moderatorFeedbackCategory
        userFlaggedAd.saveEventually()
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
