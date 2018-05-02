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
    
    func fetchModeratorStatus(key: String, completion: @escaping (ModeratorStatus?) -> Void) {
        let query = ModeratorStatus.query()
        query?.whereKey("key", equalTo: key)
        query?.getFirstObjectInBackground(block: { (object, error) in
            guard let moderatorStatus = object as? ModeratorStatus, error == nil else {
                completion(nil)
                return
            }
            
            moderatorStatus.pinInBackground(block: { (success, error) in
                print("Moderator Status Pinned: \(success)")
            })
            
            completion(moderatorStatus)
        })
    }
    
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
                    completion([])
                    return
                }
                
                completion(categories)
            })
        }
    }
}
