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

    func fetchFirstAdvert(completion: @escaping (Advert?) -> Void) {
        let query = Advert.query()
        query?.includeKey("feedbackType")
        query?.includeKey("feedbackQuestion")
        query?.getFirstObjectInBackground(block: { (advert, error) in
            guard let advert = advert as? Advert, error == nil else {
                completion(nil)
                return
            }

            completion(advert)
        })
    }

    func fetchNumberOfAdvertViews(user: PFUser, completion: @escaping (Int) -> Void) {
        let query = UserSeenAdvert.query()
        query?.whereKey("user", equalTo: user)
        query?.countObjectsInBackground(block: { (count, error) in
            guard error == nil else {
                completion(0)
                return
            }

            completion(Int(count))
        })
    }
}
