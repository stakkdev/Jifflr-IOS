//
//  FeedbackManager.swift
//  Ad-M8-iOS
//
//  Created by James Shaw on 12/10/2017.
//  Copyright © 2017 The Distance. All rights reserved.
//

import UIKit
import Parse

class FeedbackManager: NSObject {
    static let shared = FeedbackManager()

    func createQuestionAnswers(question: Question, answers: [Answer]) -> QuestionAnswers {
        let questionAnswer = QuestionAnswers()
        questionAnswer.question = question

        let relation = questionAnswer.relation(forKey: "answers")
        for answer in answers {
            relation.add(answer)
        }

        return questionAnswer
    }

    func saveFeedback(campaign: Campaign, questionAnswers: [QuestionAnswers], completion: @escaping () -> Void) {
        guard let currentUser = UserManager.shared.currentUser else { return }
        guard let location = Session.shared.currentLocation else { return }

        let group = DispatchGroup()
        for questionAnswer in questionAnswers {
            group.enter()
            questionAnswer.saveEventually({ (success, error) in
                group.leave()
            })
        }

        group.notify(queue: .main) {

            let userSeenCampaign = UserSeenCampaign()
            userSeenCampaign.campaign = campaign
            userSeenCampaign.location = location
            userSeenCampaign.user = currentUser
            
            if let currentCoordinate = Session.shared.currentCoordinate {
                userSeenCampaign.geoPoint = PFGeoPoint(latitude: currentCoordinate.latitude, longitude: currentCoordinate.longitude)
            }

            let relation = userSeenCampaign.relation(forKey: "questionAnswers")
            for questionAnswer in questionAnswers {
                relation.add(questionAnswer)
            }

            userSeenCampaign.saveEventually({ (success, error) in
                if success == true {
                    print("UserSeenAdvert Saved")
                }

                if let error = error {
                    print(error)
                }
            })
        }

        completion()
    }

    func createAndSaveAnswer(number: Int?, date: Date?) -> Answer {
        let answer = Answer()
        
        if let number = number {
            answer.text = "\(number)"
        }
        
        if let date = date {
            answer.date = date
        }
        
        answer.saveEventually { (success, error) in
            print("Answer Saved: \(success)")
            
            if let error = error {
                print(error.localizedDescription)
            }
        }
        
        return answer
    }
}
