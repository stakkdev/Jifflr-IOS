//
//  ModerationManager.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 25/04/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit
import Parse

class ModerationManager: NSObject {
    static let shared = ModerationManager()
    
    
    func fetchAllModeratorFeedback(completion: @escaping ([(category: ModeratorFeedbackCategory, feedback: [ModeratorFeedback])]) -> Void) {
        self.fetchLanguage(languageCode: Session.shared.currentLanguage) { (language) in
            guard let language = language else {
                completion([])
                return
            }
            
            let query = ModeratorFeedback.query()
            query?.includeKey("category")
            query?.includeKey("language")
            query?.whereKey("language", equalTo: language)
            query?.findObjectsInBackground(block: { (objects, error) in
                guard let moderatorFeedbacks = objects as? [ModeratorFeedback], error == nil else {
                    completion([])
                    return
                }
                
                var feedback: [(category: ModeratorFeedbackCategory, feedback: [ModeratorFeedback])] = []
                for moderatorFeedback in moderatorFeedbacks {
                    if let index = feedback.index(where: {$0.category.objectId == moderatorFeedback.category.objectId}) {
                        let existingFeedback = feedback[index]
                        var newFeedback = existingFeedback
                        newFeedback.feedback.append(moderatorFeedback)
                        newFeedback.feedback.sort(by: { (first, second) -> Bool in
                            return first.index < second.index
                        })
                        feedback[index] = newFeedback
                    } else {
                        feedback.append((category: moderatorFeedback.category, feedback: [moderatorFeedback]))
                    }
                }
                
                feedback.sort(by: { (first, second) -> Bool in
                    return first.category.index < second.category.index
                })
                
                completion(feedback)
            })
        }
    }
    
    func fetchLanguage(languageCode: String, completion: @escaping (Language?) -> Void) {
        LanguageManager.shared.fetchLanguage(languageCode: languageCode, pinName: nil) { (language) in
            guard let language = language else {
                self.fetchLanguage(languageCode: "en", completion: { (language) in
                    completion(language)
                })
                return
            }
            
            completion(language)
        }
    }
    
    func fetchAd(completion: @escaping (Advert?) -> Void) {
        guard let user = Session.shared.currentUser else { return }

//        PFCloud.callFunction(inBackground: "fetch-ads", withParameters: ["user": user.objectId!]) { responseJSON, error in
//            if let responseJSON = responseJSON as? [String: Any], error == nil {
//
//                var adverts:[Advert] = []
//                if let advert = responseJSON["defaultAd"] as? Advert {
//                    adverts.append(advert)
//                }
//
//                if let cmsAds = responseJSON["cmsAds"] as? [Advert] {
//                    adverts += cmsAds
//                }
//
//                PFObject.pinAll(inBackground: adverts, withName: self.pinName, block: { (success, error) in
//                    if success == true, error == nil {
//                        print("\(adverts.count) adverts pinned.")
//                    }
//
//                    completion()
//                })
//            } else {
//                completion()
//            }
//        }
        
        let query = Advert.query()
        query?.whereKey("creator", notEqualTo: user)
        query?.whereKey("isCMS", equalTo: true)
        query?.includeKey("questions")
        query?.includeKey("questions.answers")
        query?.includeKey("questions.type")
        query?.includeKey("details")
        query?.includeKey("details.template")
        query?.getFirstObjectInBackground(block: { (advert, error) in
            guard let advert = advert as? Advert, error == nil else {
                completion(nil)
                return
            }
            
            advert.details?.image?.getDataInBackground(block: { (data, error) in
                if let data = data, error == nil {
                    let fileExtension = UIImage(data: data) != nil ? "jpg" : "mp4"
                    let success = MediaManager.shared.save(data: data, id: advert.details?.objectId, fileExtension: fileExtension)
                    print("Moderation Media: \(advert.details?.objectId ?? "") saved to File Manager: \(success)")
                }
                
                completion(advert)
            })
        })
    }
    
    func fetchModeratorFeedbackCategories(completion: @escaping ([ModeratorFeedbackCategory]) -> Void) {
        if Reachability.isConnectedToNetwork() {
            self.fetchLanguage(languageCode: Session.shared.currentLanguage) { (language) in
                guard let language = language else {
                    completion([])
                    return
                }
                
                let query = ModeratorFeedbackCategory.query()
                query?.whereKey("language", equalTo: language)
                query?.whereKey("passed", equalTo: false)
                query?.findObjectsInBackground(block: { (objects, error) in
                    guard let categories = objects as? [ModeratorFeedbackCategory], error == nil else {
                        self.fetchLocalModeratorFeedbackCategories(completion: { (categories) in
                            completion(categories)
                        })
                        return
                    }
                    
                    PFObject.pinAll(inBackground: categories, withName: AdvertManager.shared.pinName, block: { (success, error) in
                        print("ModeratorFeedbackCategory pinned: \(success)")
                    })
                    
                    completion(categories)
                })
            }
        } else {
            self.fetchLocalModeratorFeedbackCategories(completion: { (categories) in
                completion(categories)
            })
        }
    }
    
    func fetchLocalModeratorFeedbackCategories(completion: @escaping ([ModeratorFeedbackCategory]) -> Void) {
        let query = ModeratorFeedbackCategory.query()
        query?.whereKey("passed", equalTo: false)
        query?.fromPin(withName: AdvertManager.shared.pinName)
        query?.findObjectsInBackground(block: { (objects, error) in
            guard let categories = objects as? [ModeratorFeedbackCategory], error == nil else {
                completion([])
                return
            }
            
            completion(categories)
        })
    }
    
    func fetchNonComplianceFeedback(advert: Advert, completion: @escaping ([ModeratorFeedback]) -> Void) {
        let query = ModeratorAdReview.query()
        query?.whereKey("advert", equalTo: advert)
        query?.whereKey("approved", equalTo: false)
        query?.includeKey("advert")
        query?.includeKey("feedback")
        query?.includeKey("feedback.category")
        query?.findObjectsInBackground(block: { (objects, error) in
            guard let moderatorAdReviews = objects as? [ModeratorAdReview], error == nil else {
                completion([])
                return
            }
            
            var moderatorFeedback: [ModeratorFeedback] = []
            for moderatorAdReview in moderatorAdReviews {
                for feedback in moderatorAdReview.feedback {
                    if !moderatorFeedback.contains(feedback) {
                        moderatorFeedback.append(feedback)
                    }
                }
            }
            
            completion(moderatorFeedback)
        })
    }
    
    func shouldShowNonComplianceFeedback(campaign: Campaign, completion: @escaping (Bool) -> Void) {
        guard let status = campaign.status, status.key == CampaignStatusKey.nonCompliant || status.key == CampaignStatusKey.nonCompliantScheduled else {
            completion(false)
            return
        }
        
        let query = ModeratorAdReview.query()
        query?.whereKey("advert", equalTo: campaign.advert)
        query?.whereKey("approved", equalTo: false)
        query?.countObjectsInBackground(block: { (count, error) in
            completion(Int(count) > 0)
        })
    }
}
