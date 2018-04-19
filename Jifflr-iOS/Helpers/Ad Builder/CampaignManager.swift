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
    
    let pinName = "Campaigns"
    
    func startEndDateString(schedule: Schedule) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        let startDateString = dateFormatter.string(from: schedule.startDate)
        let endDateString = dateFormatter.string(from: schedule.endDate)
        
        return "\(startDateString)    to    \(endDateString)"
    }
    
    func startEndTimeString(schedule: Schedule) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH.mm"
        
        let startDateString = dateFormatter.string(from: schedule.startDate)
        let endDateString = dateFormatter.string(from: schedule.endDate)
        
        return "\(startDateString)    to    \(endDateString)"
    }
    
    func daysOfWeekString(schedule: Schedule) -> String {
        var daysOfWeekString = ""
        
        for dayInt in schedule.daysOfWeek {
            switch dayInt {
            case 0:
                let day = "campaignOverview.days.monday".localized()
                daysOfWeekString += "\(day)  "
            case 1:
                let day = "campaignOverview.days.tuesday".localized()
                daysOfWeekString += "\(day)  "
            case 2:
                let day = "campaignOverview.days.wednesday".localized()
                daysOfWeekString += "\(day)  "
            case 3:
                let day = "campaignOverview.days.thursday".localized()
                daysOfWeekString += "\(day)  "
            case 4:
                let day = "campaignOverview.days.friday".localized()
                daysOfWeekString += "\(day)  "
            case 5:
                let day = "campaignOverview.days.saturday".localized()
                daysOfWeekString += "\(day)  "
            case 6:
                let day = "campaignOverview.days.sunday".localized()
                daysOfWeekString += "\(day)  "
            default:
                continue
            }
        }
        
        return daysOfWeekString
    }
    
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
    
    func fetchCostPerReview(location: Location, completion: @escaping (Double?) -> Void) {
        let query = LocationFinancial.query()
        query?.whereKey("location", equalTo: location)
        query?.getFirstObjectInBackground(block: { (locationFinancial, error) in
            guard let locationFinancial = locationFinancial as? LocationFinancial, error == nil else {
                completion(nil)
                return
            }
            
            let costPerReview = (Double(locationFinancial.cpmRateCMS) / 1000.0) / 100.0
            
            completion(costPerReview)
        })
    }
    
    func fetchCampaigns(completion: @escaping ([Campaign]?) -> Void) {
        guard let user = Session.shared.currentUser else { return }
        
        let query = Campaign.query()
        query?.whereKey("creator", equalTo: user)
        query?.includeKey("demographic")
        query?.includeKey("demographic.location")
        query?.includeKey("demographic.language")
        query?.includeKey("demographic.gender")
        query?.includeKey("schedule")
        query?.includeKey("advert")
        query?.includeKey("locationFinancial")
        query?.findObjectsInBackground(block: { (objects, error) in
            guard let campaigns = objects as? [Campaign], error == nil else {
                completion(nil)
                return
            }
            
            PFObject.pinAll(inBackground: campaigns, withName: self.pinName) { (success, error) in
                completion(campaigns)
            }
        })
    }
    
    func countCampaigns(completion: @escaping (Int?) -> Void) {
        guard let currentUser = Session.shared.currentUser else { return }
        
        let query = Campaign.query()
        query?.whereKey("creator", equalTo: currentUser)
        query?.countObjectsInBackground(block: { (count, error) in
            guard error == nil else {
                completion(nil)
                return
            }
            
            completion(Int(count))
        })
    }
}
