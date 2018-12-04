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

    func fetchFAQs(languageCode: String, completion: @escaping ([(category: FAQCategory, data: [FAQ])]?, ErrorMessage?) -> Void) {
        if languageCode == Session.shared.englishLanguageCode {
            self.queryFAQs(languageCode: languageCode, completion: { (faqs, error) in
                completion(faqs, error)
                return
            })
        } else {
            self.countFAQs(languageCode: languageCode, completion: { (count, error) in
                guard let count = count, error == nil else {
                    completion(nil, error)
                    return
                }

                if count == 0 {
                    self.queryFAQs(languageCode: Session.shared.englishLanguageCode, completion: { (faqs, error) in
                        completion(faqs, error)
                    })
                } else {
                    self.queryFAQs(languageCode: languageCode, completion: { (faqs, error) in
                        completion(faqs, error)
                    })
                }
            })
        }
    }

    func countFAQs(languageCode: String, completion: @escaping (Int?, ErrorMessage?) -> Void) {
        LanguageManager.shared.fetchLanguage(languageCode: languageCode, pinName: nil) { (language) in
            guard let language = language else {
                completion(nil, ErrorMessage.faqsFailed)
                return
            }
            
            let query = FAQ.query()
            query?.whereKey("language", equalTo: language)
            query?.order(byAscending: "index")
            query?.countObjectsInBackground(block: { (count, error) in
                guard error == nil else {
                    completion(nil, ErrorMessage.faqsFailed)
                    return
                }
                
                completion(Int(count), nil)
            })
        }
    }

    func queryFAQs(languageCode: String, completion: @escaping ([(category: FAQCategory, data: [FAQ])]?, ErrorMessage?) -> Void) {
        LanguageManager.shared.fetchLanguage(languageCode: languageCode, pinName: nil) { (language) in
            guard let language = language else {
                completion(nil, ErrorMessage.faqsFailed)
                return
            }
            
            let query = FAQ.query()
            query?.whereKey("language", equalTo: language)
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
                
                language.pinInBackground(withName: self.pinName, block: { (success, error) in
                    print("Language Pinned: \(success)")
                })
                
                let data = self.parseFAQs(faqs: faqs)
                completion(data, nil)
            })
        }
    }

    func fetchLocalFAQs(completion: @escaping ([(category: FAQCategory, data: [FAQ])]?, ErrorMessage?) -> Void) {
        LanguageManager.shared.fetchLanguage(languageCode: Session.shared.currentLanguage, pinName: self.pinName) { (language) in
            guard let language = language else {
                completion(nil, ErrorMessage.faqsFailed)
                return
            }
            
            let query = FAQ.query()
            query?.whereKey("language", equalTo: language)
            query?.order(byAscending: "index")
            query?.includeKey("category")
            query?.fromPin(withName: self.pinName)
            query?.findObjectsInBackground(block: { (faqs, error) in
                guard let faqs = faqs as? [FAQ], error == nil else {
                    completion(nil, ErrorMessage.faqsFailed)
                    return
                }
                
                if faqs.count > 0 {
                    let data = self.parseFAQs(faqs: faqs)
                    completion(data, nil)
                    return
                    
                } else {
                    LanguageManager.shared.fetchLanguage(languageCode: Session.shared.englishLanguageCode, pinName: self.pinName) { (language) in
                        guard let language = language else {
                            completion(nil, ErrorMessage.faqsFailed)
                            return
                        }
                        
                        let query = FAQ.query()
                        query?.whereKey("language", equalTo: language)
                        query?.order(byAscending: "index")
                        query?.includeKey("category")
                        query?.fromPin(withName: self.pinName)
                        query?.findObjectsInBackground(block: { (faqsEn, error) in
                            guard let faqsEn = faqsEn as? [FAQ], error == nil else {
                                completion(nil, ErrorMessage.faqsFailed)
                                return
                            }
                            
                            let data = self.parseFAQs(faqs: faqsEn)
                            completion(data, nil)
                        })
                    }
                }
            })
        }
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
