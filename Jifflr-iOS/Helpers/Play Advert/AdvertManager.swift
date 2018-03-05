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
//        guard let user = Session.shared.currentUser else { return }
//
//        self.countLocal { (count) in
//            guard self.shouldFetch(count: count) else {
//                completion()
//                return
//            }
//
//            PFCloud.callFunction(inBackground: "fetch-ads", withParameters: ["user": user.objectId!]) { responseJSON, error in
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
//        }

        PFObject.unpinAllObjectsInBackground(withName: self.pinName) { (success, error) in
            MockContent.init().createDefaultAdvert().pinInBackground(withName: self.pinName) { (success, error) in
                completion()
            }
        }
    }

    func countLocal(completion: @escaping (Int) -> Void) {
        let query = Advert.query()
        query?.fromPin(withName: self.pinName)
        query?.whereKey("isCMS", equalTo: true)
        query?.countObjectsInBackground(block: { (count, error) in
            guard error == nil else {
                completion(0)
                return
            }

            completion(Int(count))
        })
    }

    func fetchNextLocal(completion: @escaping (Advert?) -> Void) {
        let query = Advert.query()
        query?.fromPin(withName: self.pinName)
        query?.includeKey("questionType")
        query?.includeKey("question")
        query?.includeKey("question.answers")
        query?.whereKey("isCMS", equalTo: true)
        query?.getFirstObjectInBackground(block: { (object, error) in
            if let advert = object as? Advert, error == nil {
                completion(advert)
                return
            } else {
                self.fetchLocalDefault(completion: { (advert) in
                    completion(advert)
                    return
                })
            }
        })
    }

    func fetchLocalDefault(completion: @escaping (Advert?) -> Void) {
        let query = Advert.query()
        query?.fromPin(withName: self.pinName)
        query?.includeKey("questionType")
        query?.whereKey("isCMS", equalTo: false)
        query?.getFirstObjectInBackground(block: { (object, error) in
            guard let advert = object as? Advert, error == nil else {
                completion(nil)
                return
            }

            completion(advert)
        })
    }

    func fetchQuestion(questionType: QuestionType, completion: @escaping (Question?) -> Void) {
//        let countQuery = Question.query()
//        countQuery?.limit = 10000
//        countQuery?.whereKey("questionType", equalTo: questionType)
//        countQuery?.whereKey("active", equalTo: true)
//        countQuery?.countObjectsInBackground(block: { (count, error) in
//            guard error == nil, count > 0 else {
//                completion(nil)
//                return
//            }
//
//            let randomIndex = Int(arc4random_uniform(UInt32(count - 1)))
//            let query = Question.query()
//            query?.limit = 1
//            query?.skip = randomIndex
//            query?.whereKey("questionType", equalTo: questionType)
//            query?.whereKey("active", equalTo: true)
//            query?.includeKey("type")
//            query?.includeKey("answers")
//            query?.findObjectsInBackground(block: { (objects, error) in
//                guard let question = objects?.first as? Question, error == nil else {
//                    completion(nil)
//                    return
//                }
//
//                completion(question)
//            })
//        })
        completion(MockContent.init().createQuestion())
    }

    func shouldFetch(count: Int) -> Bool {
        if count >= 20 {
            return false
        }

        return true
    }
}
