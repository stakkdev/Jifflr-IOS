//
//  CampaignManager.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 16/04/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit
import Parse

class CampaignManager: NSObject {
    static let shared = CampaignManager()
    
    func mergeDates(date: Date, time: Date) -> Date? {
        let calendar = NSCalendar.current
        
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: time)
        
        var mergedComponments = DateComponents()
        mergedComponments.year = dateComponents.year!
        mergedComponments.month = dateComponents.month!
        mergedComponments.day = dateComponents.day!
        mergedComponments.hour = timeComponents.hour!
        mergedComponments.minute = timeComponents.minute!
        mergedComponments.second = timeComponents.second!
        
        return calendar.date(from: mergedComponments)
    }
    
    func estimatedAudienceSize(demographic: Demographic, completion: @escaping (Int?) -> Void) {
//        PFCloud.callFunction(inBackground: "estimated-audience-size", withParameters: ["demographic": demographic]) { responseJSON, error in
//            if let responseJSON = responseJSON as? [String: Any] {
//                if let size = responseJSON["size"] as? Int {
//                    completion(size)
//                }
//            } else {
//                completion(nil)
//            }
//        }
        completion(Int(arc4random_uniform(2000) + 1000))
    }
}
