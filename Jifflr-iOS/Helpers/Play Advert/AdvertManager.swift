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
            let query = Advert.query()
            query?.includeKey("questions")
            query?.includeKey("details")
            query?.includeKey("details.template")
            query?.findObjectsInBackground(block: { (adverts, error) in
                guard let adverts = adverts as? [Advert], error == nil else {
                    completion()
                    return
                }
                
                PFObject.pinAll(inBackground: adverts, withName: self.pinName, block: { (success, error) in
                    let group = DispatchGroup()
                    
                    for advert in adverts {
                        group.enter()
                        self.fetchQuestionsAndAnswers(advert: advert, completion: { (error) in
                            group.leave()
                        })
                        
                        if let details = advert.details {
                            group.enter()
                            details.pinInBackground(withName: self.pinName, block: { (success, error) in
                                group.leave()
                            })
                            
                            group.enter()
                            details.template.pinInBackground(withName: self.pinName, block: { (success, error) in
                                group.leave()
                            })
                            
                            group.enter()
                            details.image?.getDataInBackground(block: { (data, error) in
                                if let data = data, error == nil {
                                    let fileExtension = UIImage(data: data) != nil ? "jpg" : "mp4"
                                    let success = MediaManager.shared.save(data: data, id: details.objectId, fileExtension: fileExtension)
                                    print("Media: \(details.objectId ?? "") saved to File Manager: \(success)")
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
    
    func fetchQuestionsAndAnswers(advert: Advert, completion: @escaping (ErrorMessage?) -> Void) {
        guard let query = advert.questions?.query() else {
            completion(nil)
            return
        }
        
        query.includeKey("type")
        query.includeKey("answers")
        query.findObjectsInBackground { (questions, error) in
            guard let questions = questions, error == nil else {
                completion(ErrorMessage.advertFetchFailed)
                return
            }
            
            PFObject.pinAll(inBackground: questions, withName: self.pinName, block: { (success, error) in
                guard success == true, error == nil else {
                    completion(ErrorMessage.advertFetchFailed)
                    return
                }
                
                let group = DispatchGroup()
                
                var allAnswers:[Answer] = []
                for question in questions {
                    group.enter()
                    
                    let answersQuery = question.answers.query()
                    answersQuery.findObjectsInBackground(block: { (answers, error) in
                        if let answers = answers, error == nil {
                            allAnswers += answers
                        }
                        
                        question.type.pinInBackground(withName: self.pinName, block: { (success, error) in
                            group.leave()
                        })
                    })
                }
                
                group.notify(queue: .main, execute: {
                    PFObject.pinAll(inBackground: allAnswers, withName: self.pinName, block: { (success, error) in
                        guard success == true, error == nil else {
                            completion(ErrorMessage.advertFetchFailed)
                            return
                        }
                        
                        completion(nil)
                    })
                })
            })
        }
    }
    
    func fetchLocalQuestionsAndAnswers(advert: Advert, completion: @escaping ([(question: Question, answers: [Answer])]) -> Void) {
        guard let query = advert.questions?.query() else {
            completion([])
            return
        }
        
        var content: [(question: Question, answers: [Answer])] = []
        
        query.fromPin(withName: self.pinName)
        query.includeKey("type")
        query.order(byAscending: "index")
        query.findObjectsInBackground { (questions, error) in
            guard let questions = questions, error == nil else {
                completion([])
                return
            }
            
            let group = DispatchGroup()
            
            for question in questions {
                group.enter()
                
                let answersQuery = question.answers.query()
                answersQuery.fromPin(withName: self.pinName)
                answersQuery.order(byAscending: "index")
                answersQuery.findObjectsInBackground(block: { (answers, error) in
                    guard let answers = answers, error == nil else {
                        completion([])
                        return
                    }
                    
                    content.append((question: question, answers: answers))
                    group.leave()
                })
            }
            
            group.notify(queue: .main, execute: {
                completion(content)
                return
            })
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
        query?.includeKey("details")
        query?.includeKey("details.template")
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
    
    func flag(advert: String, completion: @escaping (ErrorMessage?) -> Void) {
        guard let user = Session.shared.currentUser else { return }
        
        let parameters = ["user": user.objectId!, "advert": advert]
        PFCloud.callFunction(inBackground: "flag-ad", withParameters: parameters) { responseJSON, error in
            guard error == nil else {
                completion(ErrorMessage.flagAdFailed)
                return
            }
            
            completion(nil)
        }
    }
}
