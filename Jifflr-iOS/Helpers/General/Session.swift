//
//  Session.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 25/01/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit
import Parse

final class Session {
    static let shared = Session()
    private init() {}

    var currentUser: PFUser? {
        return PFUser.current()
    }

    var currentLanguage: String {
        return Locale.current.identifier
    }
    
    var currentCurrencySymbol: String {
        let symbol = Locale.current.currencySymbol ?? "£"
        guard let isoCurrencyCode = self.currentUser?.details.location.isoCurrencyCode else {
            return symbol
        }
        
        let result = Locale.availableIdentifiers.map { Locale(identifier: $0) }.first { $0.currencyCode == isoCurrencyCode }
        return result?.currencySymbol ?? symbol
    }

    var currentLocation: Location?
    
    var currentCoordinate: CLLocationCoordinate2D?

    var englishLanguageCode: String {
        return "en"
    }
    
    var currentCampaignToModerate: CampaignToModerate?
}
