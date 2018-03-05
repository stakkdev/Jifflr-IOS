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

//    func saveFeedback(userFeedback: UserFeedback, isoCountryCode: String, advert: Advert, completion: @escaping (ErrorMessage?) -> Void) {
//
//        guard let currentUser = UserManager.shared.currentUser else {
//            completion(ErrorMessage.unknown)
//            return
//        }
//
//        self.fetchLocation(isoCountryCode: isoCountryCode) { (location, error) in
//            guard let location = location, error == nil else {
//                completion(error!)
//                return
//            }
//
//            let userSeenAdvert = UserSeenAdvert()
//            userSeenAdvert.advert = advert
//            userSeenAdvert.location = location
//            userSeenAdvert.user = currentUser
//            userSeenAdvert.userFeedback = userFeedback
//            userSeenAdvert.saveInBackground(block: { (success, error) in
//                guard success == true, error == nil else {
//                    completion(ErrorMessage.feedbackSaveFailed)
//                    return
//                }
//
//                completion(nil)
//            })
//        }
//    }
//
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
