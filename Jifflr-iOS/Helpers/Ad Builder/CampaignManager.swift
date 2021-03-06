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
    
    var campaignInEdit: Campaign?
    
    func startEndDateString(schedule: Schedule) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")!
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        let startDateString = dateFormatter.string(from: schedule.startDate)
        let endDateString = dateFormatter.string(from: schedule.endDate)
        
        return "\(startDateString)    to    \(endDateString)"
    }
    
    func startEndTimeString(schedule: Schedule) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")!
        dateFormatter.dateFormat = "HH.mm"
        
        let startDateString = dateFormatter.string(from: schedule.startDate)
        let endDateString = dateFormatter.string(from: schedule.endDate)
        
        return "\(startDateString)    to    \(endDateString)"
    }
    
    func dateString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")!
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: date)
    }
    
    func timeString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")!
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
    }
    
    func daysOfWeekString(schedule: Schedule) -> String {
        var daysOfWeekString = ""
        
        let value = schedule.daysOfWeek
        let resultArray = Days.all.map { $0 & value }
        
        for day in resultArray {
            switch day {
            case Day.Mon:
                let day = "campaignOverview.days.monday".localized()
                daysOfWeekString += "\(day)  "
            case Day.Tue:
                let day = "campaignOverview.days.tuesday".localized()
                daysOfWeekString += "\(day)  "
            case Day.Wed:
                let day = "campaignOverview.days.wednesday".localized()
                daysOfWeekString += "\(day)  "
            case Day.Thu:
                let day = "campaignOverview.days.thursday".localized()
                daysOfWeekString += "\(day)  "
            case Day.Fri:
                let day = "campaignOverview.days.friday".localized()
                daysOfWeekString += "\(day)  "
            case Day.Sat:
                let day = "campaignOverview.days.saturday".localized()
                daysOfWeekString += "\(day)  "
            case Day.Sun:
                let day = "campaignOverview.days.sunday".localized()
                daysOfWeekString += "\(day)  "
            default:
                continue
            }
        }
        
        return daysOfWeekString
    }
    
    func mergeDates(date: Date, time: Date) -> Date? {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale.current
        calendar.timeZone = TimeZone(abbreviation: "UTC")!
        
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
        var parameters = [
            "minAge": demographic.minAge,
            "maxAge": demographic.maxAge,
            "location": demographic.location.objectId!,
            "language": demographic.language.objectId!
            ] as [String : Any]
        
        if let gender = demographic.gender {
            parameters["gender"] = gender.objectId!
        }
        
        PFCloud.callFunction(inBackground: "estimated-audience-size", withParameters: parameters) { responseJSON, error in
            if let responseJSON = responseJSON as? [String: Any] {
                if let size = responseJSON["size"] as? Int {
                    completion(size)
                }
            } else {
                completion(nil)
            }
        }
    }
    
    func fetchCostPerView(location: Location, completion: @escaping (Double?, LocationFinancial?) -> Void) {
        let query = LocationFinancial.query()
        query?.whereKey("location", equalTo: location)
        query?.getFirstObjectInBackground(block: { (locationFinancial, error) in
            guard let locationFinancial = locationFinancial as? LocationFinancial, error == nil else {
                completion(nil, nil)
                return
            }
            
            let costPerView = Double(locationFinancial.cpmRateCMS) / 1000.0
            
            completion(costPerView, locationFinancial)
        })
    }
    
    func fetchCampaigns(completion: @escaping ([Campaign]?) -> Void) {
        guard let user = Session.shared.currentUser else { return }
        
        let query = Campaign.query()
        query?.whereKey("creator", equalTo: user)
        query?.whereKey("status", notEqualTo: CampaignStatusKey.deleted)
        query?.order(byDescending: "createdAt")
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
        query?.whereKey("status", notEqualTo: CampaignStatusKey.deleted)
        query?.countObjectsInBackground(block: { (count, error) in
            guard error == nil else {
                completion(nil)
                return
            }
            
            completion(Int(count))
        })
    }
    
    func getDayOfWeekBitwiseInt(dayInts: [Int]) -> Int {
        var result = 0
        for index in dayInts {
            result += Days.all[index]
        }
        return result
    }
    
    func shouldCampaignBeActiveAvailable(campaign: Campaign) -> Bool {
        guard let schedule = campaign.schedule else { return false }
        
        if Date() > schedule.startDate && Date() < schedule.endDate {
            return true
        }
        
        return false
    }
    
    func handleEnableCampaign(on: Bool, campaign: Campaign, completion: @escaping (Campaign, ErrorMessage?) -> Void) {
        guard Reachability.isConnectedToNetwork() else {
            completion(campaign, ErrorMessage.noInternetConnection)
            return
        }
        
        if on {
            let query = ModeratorCampaignReview.query()
            query?.whereKey("campaign", equalTo: campaign)
            query?.countObjectsInBackground(block: { (count, error) in
                if count > 0 && !campaign.toBeModerated {
                    if self.shouldCampaignBeActiveAvailable(campaign: campaign) {
                        campaign.status = CampaignStatusKey.availableActive
                        campaign.saveInBackground { (success, error) in
                            guard error == nil else {
                                completion(campaign, ErrorMessage.campaignActivationFailed)
                                return
                            }
                            
                            campaign.pinInBackground(withName: self.pinName)
                            completion(campaign, nil)
                        }
                    } else {
                        campaign.status = CampaignStatusKey.availableScheduled
                        campaign.saveInBackground { (success, error) in
                            guard error == nil else {
                                completion(campaign, ErrorMessage.campaignActivationFailed)
                                return
                            }
                            
                            campaign.pinInBackground(withName: self.pinName)
                            completion(campaign, nil)
                        }
                    }
                } else {
                    campaign.status = CampaignStatusKey.pendingModeration
                    campaign.saveInBackground { (success, error) in
                        guard error == nil else {
                            completion(campaign, ErrorMessage.campaignActivationFailed)
                            return
                        }
                        
                        campaign.pinInBackground(withName: self.pinName)
                        completion(campaign, nil)
                    }
                }
            })
        } else {
            campaign.status = CampaignStatusKey.inactive
            campaign.saveInBackground { (success, error) in
                guard error == nil else {
                    completion(campaign, ErrorMessage.campaignActivationFailed)
                    return
                }
                
                campaign.pinInBackground(withName: self.pinName)
                completion(campaign, nil)
            }
        }
    }
    
    func withdraw(amount: Double, completion: @escaping (ErrorMessage?) -> Void) {
        guard let user = Session.shared.currentUser else { return }
        
        let pence = amount * 100.0
        let parameters = ["user": user.objectId!, "amount": pence] as [String : Any]
        
        PFCloud.callFunction(inBackground: "withdraw", withParameters: parameters) { responseJSON, error in
            if let success = responseJSON as? Bool, error == nil {
                if success == true {
                    completion(nil)
                    return
                } else {
                    completion(ErrorMessage.withdrawalFailed)
                    return
                }
            } else {
                if let _ = error {
                    completion(ErrorMessage.withdrawalFailed)
                } else {
                    completion(ErrorMessage.unknown)
                }
            }
        }
    }
    
    func updateCampaignBudget(campaign: Campaign, user: PFUser, amount: Double) {
        campaign.budget = (campaign.budget + amount) * 100
        campaign.balance = (campaign.balance + amount) * 100
        
        let newUserBalance = user.details.campaignBalance - amount
        user.details.campaignBalance = newUserBalance
    }
    
    func getCampaignResults(campaign: Campaign, completion: @escaping (ErrorMessage?) -> Void) {
        guard let user = Session.shared.currentUser else { return }
        
        let parameters = ["user": user.objectId!, "campaign": campaign.objectId!]
        
        PFCloud.callFunction(inBackground: "get-campaign-results", withParameters: parameters) { responseJSON, error in
            if let success = responseJSON as? Bool, error == nil {
                if success == true {
                    completion(nil)
                    return
                } else {
                    completion(ErrorMessage.getCampaignResultsFailed)
                    return
                }
            } else {
                if let _ = error {
                    completion(ErrorMessage.getCampaignResultsFailed)
                } else {
                    completion(ErrorMessage.unknown)
                }
            }
        }
    }
    
    func isValidBalance(balance: Double, campaign: Campaign, completion: @escaping (Bool, ErrorMessage?, String?) -> Void ) {
        guard balance >= campaign.budget && balance != 0.0 else {
            completion(false, ErrorMessage.campaignActivationFailedInvalidBalance, nil)
            return
        }
        
        guard let location = campaign.demographic?.location else {
            completion(false, ErrorMessage.campaignActivationFailedInvalidBalance, nil)
            return
        }
        
        let query = LocationFinancial.query()
        query?.whereKey("location", equalTo: location)
        query?.getFirstObjectInBackground(block: { (locationFinancial, error) in
            guard let locationFinancial = locationFinancial as? LocationFinancial, error == nil else {
                completion(false, ErrorMessage.budgetLessThanAdSubmissionFee, nil)
                return
            }
            
            let adSubmissionFee = Double(Double(locationFinancial.adSubmissionFee) / 100.0)
            let valid = balance > adSubmissionFee
            completion(valid, valid ? nil : ErrorMessage.budgetLessThanAdSubmissionFee, "\(String(format: "%.2f", adSubmissionFee))")
        })
    }
    
    func canActivateCampaign(budgetViewValue: Double, campaignBudget: Double, userCampaignBalance: Double) -> Bool {
        let budget = budgetViewValue - campaignBudget
        guard userCampaignBalance >= budget else {
            return false
        }
        
        return true
    }
    
    func activateCampaign(user: PFUser, campaign: Campaign, budget: Double) {
        campaign.status = CampaignStatusKey.pendingModeration
        campaign.budget = budget * 100
        campaign.balance = budget * 100
        campaign.creator = user
        
        let newUserBalance = user.details.campaignBalance - budget
        user.details.campaignBalance = newUserBalance
    }
    
    func copy(campaign: Campaign, completion: @escaping (Campaign?) -> Void) {
        
        let location = campaign.locationFinancial.location
        CampaignManager.shared.fetchCostPerView(location: location) { (costPerView, locationFinancial) in
            CampaignManager.shared.estimatedAudienceSize(demographic: campaign.demographic!, completion: { (size) in
                
                let newCampaign = Campaign()
                newCampaign.budget = 0.0
                newCampaign.costPerView = costPerView ?? campaign.costPerView
                newCampaign.name = campaign.name
                newCampaign.creator = campaign.creator
                newCampaign.locationFinancial = locationFinancial ?? campaign.locationFinancial
                newCampaign.advert = campaign.advert
                
                let newSchedule = Schedule()
                newSchedule.daysOfWeek = campaign.schedule!.daysOfWeek
                newSchedule.endDate = campaign.schedule!.endDate
                newSchedule.startDate = campaign.schedule!.startDate
                newCampaign.schedule = newSchedule
                
                let newDemographic = Demographic()
                newDemographic.estimatedAudience = size ?? campaign.demographic!.estimatedAudience
                
                if let gender = campaign.demographic?.gender {
                    newDemographic.gender = gender
                }
                
                newDemographic.minAge = campaign.demographic!.minAge
                newDemographic.maxAge = campaign.demographic!.maxAge
                newDemographic.language = campaign.demographic!.language
                newDemographic.location = campaign.demographic!.location
                newCampaign.demographic = newDemographic
                
                completion(newCampaign)
            })
        }
    }
    
    func topUp(token: String, amount: Double, completion: @escaping (ErrorMessage?) -> Void) {
        let pence = Int((amount * 100).rounded(.up))
        let parameters = ["token": token, "amount": pence] as [String : Any]
        
        PFCloud.callFunction(inBackground: "top-up", withParameters: parameters) { responseJSON, error in
            if let responseJSON = responseJSON as? [String: Bool], error == nil {
                if responseJSON["success"] == true {
                    completion(nil)
                    return
                } else {
                    completion(ErrorMessage.paypalTopUpFailed)
                    return
                }
            } else {
                if let _ = error {
                    completion(ErrorMessage.paypalTopUpFailed)
                } else {
                    completion(ErrorMessage.unknown)
                }
            }
        }
    }
    
    func getAdSubmissionFee(demographic: Demographic, completion: @escaping (Int) -> Void ) {
        let query = LocationFinancial.query()
        query?.whereKey("location", equalTo: demographic.location)
        query?.getFirstObjectInBackground(block: { (locationFinancial, error) in
            guard let locationFinancial = locationFinancial as? LocationFinancial, error == nil else {
                completion(2)
                return
            }
            
            let adSubmissionFee = locationFinancial.adSubmissionFee / 100
            completion(adSubmissionFee)
        })
    }
    
    func fetchMyBalance(completion: @escaping (MyBalance?, ErrorMessage?) -> Void) {
        guard let user = Session.shared.currentUser else { return }

        PFCloud.callFunction(inBackground: "available-to-withdraw", withParameters: ["user": user.objectId!]) { myBalanceJson, error in
            if let myBalanceJson = myBalanceJson as? [String: Any] {
                let myBalance = MyBalance()

                if let totalBalance = myBalanceJson["totalBalance"] as? Double {
                    myBalance.totalBalance = totalBalance
                }
                
                if let credit = myBalanceJson["credit"] as? Double {
                    myBalance.credit = credit
                }
                
                if let availableBalance = myBalanceJson["availableBalance"] as? Double {
                    myBalance.availableBalance = availableBalance
                }


                PFObject.unpinAllObjectsInBackground(withName: myBalance.pinName, block: { (success, error) in
                    myBalance.pinInBackground(withName: myBalance.pinName, block: { (success, error) in
                        print("MyBalance Pinned: \(success)")

                        if let error = error {
                            print("Error: \(error)")
                        }
                    })
                })

                completion(myBalance, nil)
            } else {
                completion(nil, ErrorMessage.unknown)
            }
        }
    }
}
