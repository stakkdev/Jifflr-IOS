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

    func saveFeedback(advert: Advert, questionAnswers: [QuestionAnswers], completion: @escaping () -> Void) {
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

            let userSeenAdvert = UserSeenAdvert()
            userSeenAdvert.advert = advert
            userSeenAdvert.location = location
            userSeenAdvert.user = currentUser

            let relation = userSeenAdvert.relation(forKey: "questionAnswers")
            for questionAnswer in questionAnswers {
                relation.add(questionAnswer)
            }

            userSeenAdvert.saveEventually({ (success, error) in
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

//    func fetchLocation(isoCountryCode: String, completion: @escaping (Location?, ErrorMessage?) -> Void) {
//        let query = Location.query()
//        query?.whereKey("isoCountryCode", equalTo: isoCountryCode)
//        query?.getFirstObjectInBackground(block: { (location, error) in
//            guard error == nil else {
//                completion(nil, ErrorMessage.parseError(error!.localizedDescription))
//                return
//            }
//
//            guard let location = location as? Location else {
//                completion(nil, ErrorMessage.locationNotSupported)
//                return
//            }
//
//            completion(location, nil)
//        })
//    }
}
