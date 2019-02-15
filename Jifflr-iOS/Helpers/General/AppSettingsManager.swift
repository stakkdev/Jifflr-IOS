//
//  AppSettingsManager.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 25/04/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit
import Parse

class AppSettingsManager: NSObject {
    static let shared = AppSettingsManager()
    
    var canViewAds = true
    
    func canBecomeModerator(completion: @escaping (Bool) -> Void) {
        PFCloud.callFunction(inBackground: "can-become-moderator", withParameters: [:]) { responseJSON, error in
            if let responseJSON = responseJSON as? [String: Bool], error == nil {
                if let yes = responseJSON["success"] {
                    completion(yes)
                } else {
                    completion(false)
                }
            } else {
                completion(false)
            }
        }
    }
    
    func updateQuestionDuration() {
        let query = AppSettings.query()
        query?.getFirstObjectInBackground(block: { (object, error) in
            guard let appSettings = object as? AppSettings, error == nil else { return }
            UserDefaultsManager.shared.setQuestionDuration(time: appSettings.questionDuration)
        })
    }
    
    func canViewAds(currentCount: Int, completion: @escaping (Bool) -> Void) {
        let query = AppSettings.query()
        query?.getFirstObjectInBackground(block: { (object, error) in
            guard let appSettings = object as? AppSettings, error == nil else {
                completion(false)
                return
            }
            
            self.canViewAds = currentCount < appSettings.adsSeenCap
            completion(self.canViewAds)
            return
        })
    }
    
    func validCashOutAmount(pounds: Double, completion: @escaping (ErrorMessage?) -> Void) {
        let query = AppSettings.query()
        query?.getFirstObjectInBackground(block: { (object, error) in
            guard let appSettings = object as? AppSettings, error == nil else {
                completion(ErrorMessage.unknown)
                return
            }
            
            let amount = "\(Session.shared.currentCurrencySymbol)\(String(format: "%.2f", appSettings.minCashout))"
            let error = pounds < appSettings.minCashout ? ErrorMessage.minCashoutAmount(amount) : nil
            completion(error)
            return
        })
    }
}
