//
//  ModerationManager.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 25/04/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit

class ModerationManager: NSObject {
    static let shared = ModerationManager()
    
    func fetchModeratorStatus(key: String, completion: @escaping (ModeratorStatus?) -> Void) {
        let query = ModeratorStatus.query()
        query?.whereKey("key", equalTo: key)
        query?.getFirstObjectInBackground(block: { (object, error) in
            guard let moderatorStatus = object as? ModeratorStatus, error == nil else {
                completion(nil)
                return
            }
            
            completion(moderatorStatus)
        })
    }
}
