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
        return Locale.current.languageCode ?? "en"
    }
    
    var currentCurrencySymbol: String {
        return Locale.current.currencySymbol ?? "£"
    }
    
    var currentCurrencyCode: String {
        return Locale.current.currencyCode ?? "en"
    }

    var currentLocation: Location?
    
    var currentCoordinate: CLLocationCoordinate2D?

    var englishLanguageCode: String {
        return "en"
    }
}
