//
//  Campaign.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 16/04/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit
import Foundation
import Parse

final class Campaign: PFObject {
    
    var advert: Advert {
        get {
            return self["advert"] as! Advert
        }
        set {
            self["advert"] = newValue
        }
    }
    
    var demographic: Demographic? {
        get {
            return self["demographic"] as? Demographic
        }
        set {
            self["demographic"] = newValue
        }
    }
    
    var schedule: Schedule? {
        get {
            return self["schedule"] as? Schedule
        }
        set {
            self["schedule"] = newValue
        }
    }
    
    var budget: Double {
        get {
            return self["budget"] as? Double ?? 0.0
        }
        set {
            self["budget"] = newValue
        }
    }
    
    var name: String {
        get {
            return self["name"] as! String
        }
        set {
            self["name"] = newValue
        }
    }
    
    var locationFinancial: LocationFinancial {
        get {
            return self["locationFinancial"] as! LocationFinancial
        }
        set {
            self["locationFinancial"] = newValue
        }
    }
    
    var costPerReview: Double {
        get {
            return self["costPerReview"] as! Double
        }
        set {
            self["costPerReview"] = newValue
        }
    }
    
    var number: Int {
        get {
            return self["number"] as? Int ?? 0
        }
        set {
            self["number"] = newValue
        }
    }
    
    var creator: PFUser {
        get {
            return self["creator"] as! PFUser
        }
        set {
            self["creator"] = newValue
        }
    }
    
    var status: CampaignStatus? {
        get {
            return self["status"] as? CampaignStatus
        }
        set {
            self["status"] = newValue
        }
    }
}

extension Campaign: PFSubclassing {
    static func parseClassName() -> String {
        return "Campaign"
    }
}

extension Campaign {
    func saveAndPin(completion: @escaping () -> Void ) {
        self.demographic?.saveEventually()
        self.schedule?.saveEventually()
        self.saveEventually()
        
        let group = DispatchGroup()
        
        group.enter()
        self.demographic?.gender?.pinInBackground(withName: CampaignManager.shared.pinName, block: { (success, error) in
            group.leave()
        })
        
        group.enter()
        self.demographic?.location.pinInBackground(withName: CampaignManager.shared.pinName, block: { (success, error) in
            group.leave()
        })
        
        group.enter()
        self.demographic?.language.pinInBackground(withName: CampaignManager.shared.pinName, block: { (success, error) in
            group.leave()
        })
        
        group.enter()
        self.demographic?.pinInBackground(withName: CampaignManager.shared.pinName, block: { (success, error) in
            group.leave()
        })
        
        group.enter()
        self.schedule?.pinInBackground(withName: CampaignManager.shared.pinName, block: { (success, error) in
            group.leave()
        })
        
        group.enter()
        self.pinInBackground(withName: CampaignManager.shared.pinName, block: { (success, error) in
            group.leave()
        })
        
        group.notify(queue: .main) {
            completion()
        }
    }
    
    func saveInBackgroundAndPin(completion: @escaping (ErrorMessage?) -> Void ) {
        self.demographic?.saveInBackground(block: { (success, error) in
            guard success == true, error == nil else {
                completion(ErrorMessage.copyCampaignFailed)
                return
            }
            
            self.schedule?.saveInBackground(block: { (success, error) in
                guard success == true, error == nil else {
                    completion(ErrorMessage.copyCampaignFailed)
                    return
                }
                
                self.saveInBackground(block: { (success, error) in
                    guard success == true, error == nil else {
                        completion(ErrorMessage.copyCampaignFailed)
                        return
                    }
                    
                    let group = DispatchGroup()
                    
                    group.enter()
                    self.demographic?.gender?.pinInBackground(withName: CampaignManager.shared.pinName, block: { (success, error) in
                        group.leave()
                    })
                    
                    group.enter()
                    self.demographic?.location.pinInBackground(withName: CampaignManager.shared.pinName, block: { (success, error) in
                        group.leave()
                    })
                    
                    group.enter()
                    self.demographic?.language.pinInBackground(withName: CampaignManager.shared.pinName, block: { (success, error) in
                        group.leave()
                    })
                    
                    group.enter()
                    self.demographic?.pinInBackground(withName: CampaignManager.shared.pinName, block: { (success, error) in
                        group.leave()
                    })
                    
                    group.enter()
                    self.schedule?.pinInBackground(withName: CampaignManager.shared.pinName, block: { (success, error) in
                        group.leave()
                    })
                    
                    group.enter()
                    self.pinInBackground(withName: CampaignManager.shared.pinName, block: { (success, error) in
                        group.leave()
                    })
                    
                    group.notify(queue: .main) {
                        completion(nil)
                    }
                })
            })
        })
    }
}
