//
//  AdvertManager.swift
//  Ad-M8-iOS
//
//  Created by James Shaw on 12/10/2017.
//  Copyright © 2017 The Distance. All rights reserved.
//

import UIKit

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
}
