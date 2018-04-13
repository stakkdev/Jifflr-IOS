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
    
    let pinName = AdvertManager.shared.pinName
    
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
    
    func fetchTemplates(local: Bool, completion: @escaping ([AdvertTemplate]) -> Void) {
        let query = AdvertTemplate.query()
        query?.order(byAscending: "index")
        if local { query?.fromPin(withName: self.pinName) }
        query?.findObjectsInBackground(block: { (objects, error) in
            guard let templates = objects as? [AdvertTemplate], error == nil else {
                completion([])
                return
            }
            
            if !local {
                PFObject.pinAll(inBackground: templates, withName: self.pinName, block: { (success, error) in
                    print("Templates Pinned: \(success)")
                })
            }
            
            completion(templates)
        })
    }
    
    func fetchQuestionTypes(local: Bool, completion: @escaping ([QuestionType]) -> Void) {
        let query = QuestionType.query()
        query?.order(byAscending: "type")
        if local { query?.fromPin(withName: self.pinName) }
        query?.whereKey("type", notEqualTo: AdvertQuestionType.Swipe)
        query?.findObjectsInBackground(block: { (objects, error) in
            guard let questionTypes = objects as? [QuestionType], error == nil else {
                completion([])
                return
            }
            
            if !local {
                PFObject.pinAll(inBackground: questionTypes, withName: self.pinName, block: { (success, error) in
                    print("Question Types Pinned: \(success)")
                })
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
        
        print("Index: \(index)")
        
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
    
    func saveAndPin(advert: Advert, content: [(question: Question, answers: [Answer])], completion: @escaping (ErrorMessage?) -> Void) {
        
        self.saveAndPinContent(contentArray: content, completion: { (questions, error)  in
            guard questions.count > 0, error == nil else {
                completion(ErrorMessage.saveAdFailed)
                return
            }
            
            advert.addQuestions(questions: questions)
            advert.saveInBackground { (success, error) in
                guard success == true, error == nil else {
                    completion(ErrorMessage.saveAdFailed)
                    return
                }
                
                advert.pinInBackground(withName: self.pinName, block: { (success, error) in
                    guard success == true, error == nil else {
                        completion(ErrorMessage.saveAdFailed)
                        return
                    }
                    
                    print("Advert Saved and Pinned")
                    completion(nil)
                })
            }
        })
    }
    
    func saveAndPinContent(contentArray: [(question: Question, answers: [Answer])], completion: @escaping ([Question], ErrorMessage?) -> Void) {
        let group = DispatchGroup()
        var questions:[Question] = []
        
        for content in contentArray {
            group.enter()
            
            let question = content.question
            let answers = content.answers
            questions.append(question)
            
            PFObject.saveAll(inBackground: answers) { (success, error) in
                guard success == true, error == nil else {
                    completion([], ErrorMessage.saveAdFailed)
                    return
                }
                
                PFObject.pinAll(inBackground: answers, withName: self.pinName, block: { (success, error) in
                    print("Answers Saved: \(success)")
                })
                
                question.setAnswers(answers: answers)
                question.saveInBackground(block: { (success, error) in
                    guard success == true, error == nil else {
                        completion([], ErrorMessage.saveAdFailed)
                        return
                    }
                    
                    question.pinInBackground(withName: self.pinName, block: { (success, error) in
                        print("Question Saved: \(success)")
                    })
                    
                    group.leave()
                })
            }
        }
        
        group.notify(queue: .main) {
            completion(questions, nil)
        }
    }
}
