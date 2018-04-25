//
//  LanguageManager.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 17/04/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit

class LanguageManager: NSObject {
    static let shared = LanguageManager()
    
    func fetchLanguages(completion: @escaping ([Language]) -> Void) {
        let query = Language.query()
        query?.order(byAscending: "name")
        query?.findObjectsInBackground(block: { (objects, error) in
            guard let languages = objects as? [Language], error == nil else {
                completion([])
                return
            }
            
            completion(languages)
        })
    }
    
    func fetchLanguage(languageCode: String, pinName: String?, completion: @escaping (Language?) -> Void) {
        let query = Language.query()
        if let pinName = pinName { query?.fromPin(withName: pinName) }
        query?.whereKey("languageCode", equalTo: languageCode)
        query?.getFirstObjectInBackground(block: { (object, error) in
            guard let language = object as? Language, error == nil else {
                completion(nil)
                return
            }
            
            completion(language)
        })
    }
}
