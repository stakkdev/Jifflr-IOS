//
//  AdBuilderManager.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 26/03/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit
import Parse

class AdBuilderManager: NSObject {
    static let shared = AdBuilderManager()
    
    let pinName = "AdBuilder"
    
    func countUserAds(completion: @escaping (Int?) -> Void) {
        guard let currentUser = Session.shared.currentUser else { return }
        
        let query = Advert.query()
        query?.whereKey("creator", equalTo: currentUser)
        query?.countObjectsInBackground(block: { (count, error) in
            guard error == nil else {
                completion(nil)
                return
            }
            
            completion(Int(count))
        })
    }
    
    func countLocalUserAds(completion: @escaping (Int?) -> Void) {
        guard let currentUser = Session.shared.currentUser else { return }
        
        let query = Advert.query()
        query?.whereKey("creator", equalTo: currentUser)
        query?.fromPin(withName: self.pinName)
        query?.countObjectsInBackground(block: { (count, error) in
            guard error == nil else {
                completion(nil)
                return
            }
            
            completion(Int(count))
        })
    }
    
    func fetchTemplates(completion: @escaping ([AdvertTemplate]) -> Void) {
        let query = AdvertTemplate.query()
        query?.order(byAscending: "index")
        query?.findObjectsInBackground(block: { (objects, error) in
            guard let templates = objects as? [AdvertTemplate], error == nil else {
                completion([])
                return
            }
            
            completion(templates)
        })
    }
    
    func fetchQuestionTypes(completion: @escaping ([QuestionType]) -> Void) {
        let query = QuestionType.query()
        query?.order(byAscending: "type")
        query?.whereKey("type", notEqualTo: AdvertQuestionType.Swipe)
        query?.findObjectsInBackground(block: { (objects, error) in
            guard let questionTypes = objects as? [QuestionType], error == nil else {
                completion([])
                return
            }
            
            completion(questionTypes)
        })
    }
    
    func createQuestion(index: Int, text: String, type: QuestionType, noOfRequiredAnswers: Int?) -> Question {
        let question = Question()
        question.active = false
        question.index = index
        question.type = type
        question.text = text
        
        if let noOfRequiredAnswers = noOfRequiredAnswers {
            question.noOfRequiredAnswers = noOfRequiredAnswers
        }
        
        return question
    }
    
    func createAnswer(index: Int, content: Any) -> Answer {
        let answer = Answer()
        answer.index = index
        
        if let date = content as? Date {
            answer.date = date
        }
        
        if let text = content as? String {
            answer.text = text
        }
        
        return answer
    }
    
    func fetchDefaultAnswers(questionType: QuestionType, completion: @escaping ([Answer]) -> Void) {
        let query = Answer.query()
        query?.order(byAscending: "index")
        query?.whereKey("questionType", equalTo: questionType)
        query?.findObjectsInBackground(block: { (objects, error) in
            guard let answers = objects as? [Answer], error == nil else {
                completion([])
                return
            }
            
            completion(answers)
        })
    }
}
