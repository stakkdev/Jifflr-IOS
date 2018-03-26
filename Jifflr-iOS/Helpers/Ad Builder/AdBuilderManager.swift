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
    
    let pinName = "AdBuilder"
    
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
    
    func fetchTemplates(completion: @escaping ([AdvertTemplate]) -> Void) {
        let query = AdvertTemplate.query()
        query?.order(byAscending: "index")
        query?.findObjectsInBackground(block: { (objects, error) in
            guard let templates = objects as? [AdvertTemplate], error == nil else {
                completion([])
                return
            }
            
            completion(templates)
        })
    }
}
