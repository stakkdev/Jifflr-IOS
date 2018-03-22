//
//  Constants.swift
//  Ad-M8-iOS
//
//  Created by James Shaw on 09/10/2017.
//  Copyright © 2017 The Distance. All rights reserved.
//

import TDOnboarding

struct Constants {

    static let currentEnvironment: Environment = {
        if let configuration = Bundle.main.object(forInfoDictionaryKey: "Configuration") as? String {
            if configuration.lowercased().range(of: "staging") != nil {
                return Environment.staging
            }
        }
        return Environment.production
    }()

    struct Notifications {
        static let locationFound = Notification.Name(rawValue: "locationFound")
        static let locationPermissionsChanged = Notification.Name(rawValue: "locationPermissionsChanged")
    }

    struct FontNames {
        static let GothamBold = "GothamBold"
        static let GothamBook = "GothamBook"
        static let GothamMedium = "GothamMedium"
    }

    static var isSmallScreen: Bool {
        return UIScreen.main.nativeBounds.height <= 1136
    }

    static let RegistrationGenders = [
        "register.gender.option1".localized(),
        "register.gender.option2".localized(),
        "register.gender.option3".localized(),
        "register.gender.option4".localized(),
        "register.gender.option5".localized(),
        "register.gender.option6".localized(),
        "register.gender.option7".localized()
    ]
}

enum Environment: String {
    case staging
    case production

    var appURL: String {
        switch self {
        case .staging:
            return "https://jifflr.thecore.thedistance.co.uk/parse"
        case .production:
            return "https://jifflr.thedistance.co.uk/parse"
        }
    }

    var appodealKey: String {
        switch self {
        case .staging:
            return "d79d7acb562b96dfc542d052d4bbce859ca1ff9f788a2504"
        case .production:
            return "d79d7acb562b96dfc542d052d4bbce859ca1ff9f788a2504"
        }
    }

    var appodealTesting: Bool {
        switch self {
        case .staging:
            return true
        case .production:
            return false
        }
    }

    var admobKey: String {
        switch self {
        case .staging:
            return "ca-app-pub-3940256099942544/1712485313" // This is the sample unit ID provided by Google for testing
        case .production:
            return "ca-app-pub-3023125219328196/3793918089"
        }
    }
}

struct OnboardingCustomizable: TDOnboardingCustomizable {
    var titleTextColor: UIColor {
        return UIColor.clear
    }

    var titleFont: UIFont? {
        return UIFont(name: Constants.FontNames.GothamBold, size: 18.0)
    }

    var bottomTitleTextColor: UIColor? {
        return UIColor.mainBlue
    }

    var bottomTitleFont: UIFont? {
        return UIFont(name: Constants.FontNames.GothamBold, size: 18.0)
    }

    var pageControlSelectedTintColor: UIColor {
        return UIColor.mainBlue
    }

    var pageControlTintColor: UIColor {
        return UIColor.mainBlueTransparent40
    }

    var subtitleTextColor: UIColor {
        return UIColor.mainBlue
    }

    var subTitleFont: UIFont? {
        return UIFont(name: Constants.FontNames.GothamBook, size: 13.5)
    }

    var subtitleLineHeight: CGFloat? {
        return 19
    }

    var closeButtonTitle: String {
        return "onboarding.closeButton".localized()
    }

    var skipButtonTitle: String {
        return "onboarding.skipButton".localized()
    }

    var skipButtonFont: UIFont? {
        return UIFont(name: Constants.FontNames.GothamBook, size: 16.0)
    }

    var skipButtonColor: UIColor? {
        return UIColor.white
    }

    var specialLastChild: Bool {
        return false
    }

    var bgImageOverlayColor: UIColor {
        return UIColor.clear
    }

    var textBackgroundColor: UIColor? {
        return UIColor.white
    }
}

struct Onboarding {
    static var titles: [String] {
        return [
            "onboarding.title1".localized(),
            "onboarding.title2".localized(),
            "onboarding.title3".localized()
        ]
    }

    static var subTitles: [String] {
        return [
            "onboarding.description1".localized(),
            "onboarding.description2".localized(),
            "onboarding.description3".localized()
        ]
    }

    static var images: [UIImage] {
        return [
            #imageLiteral(resourceName: "Onboarding1"),
            #imageLiteral(resourceName: "Onboarding1"),
            #imageLiteral(resourceName: "Onboarding1")
        ]
    }

    static var bgImage: UIImage {
        return #imageLiteral(resourceName: "OnboardingBackground")
    }
}

struct AdvertQuestionType {
    static let Binary = 0
    static let Scale = 1
    static let MultiSelect = 2
    static let Swipe = 3
    static let NumberPicker = 4
    static let TimePicker = 5
    static let DatePicker = 6
}

struct LocationStatusType {
    static let Active = 0
    static let Disabled = 1
    static let AllowCashOut = 2
}
