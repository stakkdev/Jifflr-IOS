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
}

enum Environment: String {
    case staging
    case production

    var appURL: String {
        switch self {
        case .staging:
            return "https://adm8.thecore.thedistance.co.uk/parse"
        case .production:
            return "https://adm8.thedistance.co.uk/parse"
        }
    }
}

struct OnboardingCustomizable: TDOnboardingCustomizable {
    var titleTextColor: UIColor {
        return UIColor.mainBlue
    }

    var pageControlSelectedTintColor: UIColor {
        return UIColor.mainBlue
    }

    var pageControlTintColor: UIColor {
        return UIColor.red
    }

    var subtitleFontSize: CGFloat {
        return 13.5
    }

    var subtitleTextColor: UIColor {
        return UIColor.mainBlue
    }

    var closeButtonTitle: String {
        return "Skip"
    }

    var skipButtonTitle: String {
        return "Skip"
    }

    var specialLastChild: Bool {
        return false
    }

    var bgImageOverlayColor: UIColor {
        return UIColor.clear
    }

    var subTitleFont: UIFont? {
        return UIFont.systemFont(ofSize: 13.5, weight: .semibold)
    }

    var skipButtonFont: UIFont? {
        return UIFont.systemFont(ofSize: 16.0, weight: .semibold)
    }

    var skipButtonColor: UIColor? {
        return UIColor.white
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
        return #imageLiteral(resourceName: "Onboarding1")
    }
}
