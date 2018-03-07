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

    func createQuestionAnswers(question: Question, answers: [String]) -> QuestionAnswers {
        let questionAnswer = QuestionAnswers()
        questionAnswer.question = question
        questionAnswer.answers = answers
        return questionAnswer
    }

    func saveFeedback(advert: Advert, questionAnswers: [QuestionAnswers], completion: @escaping () -> Void) {
        guard let currentUser = UserManager.shared.currentUser else { return }

        if let location = Session.shared.currentLocation {
            let userSeenAdvert = UserSeenAdvert()
            userSeenAdvert.advert = advert
            userSeenAdvert.location = location
            userSeenAdvert.user = currentUser
            userSeenAdvert.questionAnswers = PFRelation()

            for questionAnswer in questionAnswers {
                userSeenAdvert.questionAnswers.add(questionAnswer)
            }

            userSeenAdvert.saveEventually({ (success, error) in
                if success == true {
                    print("UserSeenAdvert Saved")
                }

                if let error = error {
                    print(error)
                }
            })

            completion()
        }
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
