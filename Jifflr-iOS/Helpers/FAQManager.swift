//
//  FAQManager.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 19/02/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit
import Parse

class FAQManager: NSObject {
    static let shared = FAQManager()

    let pinName = "FAQs"

    func fetchFAQs(completion: @escaping ([(category: FAQCategory, data: [FAQ])]?, ErrorMessage?) -> Void) {
        let query = FAQ.query()
        query?.whereKey("languageCode", equalTo: Session.shared.currentLanguage)
        query?.order(byAscending: "index")
        query?.includeKey("category")
        query?.findObjectsInBackground(block: { (faqs, error) in
            guard let faqs = faqs as? [FAQ], error == nil else {
                completion(nil, ErrorMessage.faqsFailed)
                return
            }

            PFObject.pinAll(inBackground: faqs, withName: self.pinName, block: { (success, error) in
                print("FAQs Pinned: \(success)")

                if let error = error {
                    print("Error: \(error)")
                }
            })

            let data = self.parseFAQs(faqs: faqs)
            completion(data, nil)
        })
    }

    func fetchLocalFAQs(completion: @escaping ([(category: FAQCategory, data: [FAQ])]?, ErrorMessage?) -> Void) {
        let query = FAQ.query()
        query?.whereKey("languageCode", equalTo: Session.shared.currentLanguage)
        query?.order(byAscending: "index")
        query?.includeKey("category")
        query?.fromPin(withName: self.pinName)
        query?.findObjectsInBackground(block: { (faqs, error) in
            guard let faqs = faqs as? [FAQ], error == nil else {
                completion(nil, ErrorMessage.faqsFailed)
                return
            }

            let data = self.parseFAQs(faqs: faqs)
            completion(data, nil)
        })
    }

    func parseFAQs(faqs: [FAQ]) -> [(category: FAQCategory, data: [FAQ])] {

        var tupleArray:[(category: FAQCategory, data: [FAQ])] = []

        for faq in faqs {
            if let index = tupleArray.index(where: { $0.category == faq.category } ) {
                let existingData = tupleArray[index].data
                var newData = existingData
                newData.append(faq)
                tupleArray[index].data = newData
            } else {
                tupleArray.append((category: faq.category, data: [faq]))
            }
        }

        tupleArray.sort { (first, second) -> Bool in
            return first.category.index < second.category.index
        }

        return tupleArray
    }
}
