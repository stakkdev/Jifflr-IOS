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
            
            if configuration.lowercased().range(of: "testing") != nil {
                return Environment.testing
            }
        }
        return Environment.production
    }()

    struct Notifications {
        static let locationFound = Notification.Name(rawValue: "locationFound")
        static let locationPermissionsChanged = Notification.Name(rawValue: "locationPermissionsChanged")
        static let tableViewHeightChanged = Notification.Name(rawValue: "tableViewHeightChanged")
    }

    struct FontNames {
        static let GothamBold = "GothamBold"
        static let GothamBook = "GothamBook"
        static let GothamMedium = "GothamMedium"
    }

    static var isSmallScreen: Bool {
        return UIScreen.main.nativeBounds.height <= 1136
    }
    
    struct UrlPaths {
        static let media = URL(fileURLWithPath: "/assets/")
    }
}

enum Environment: String {
    case staging
    case production
    case testing

    var appURL: String {
        switch self {
        case .staging:
            return Secrets.stagingAPPURL
        case .testing:
            return Secrets.testingAPPURL
        case .production:
            return Secrets.productionAPPURL
        }
    }

    var appodealKey: String {
        return Secrets.appodealKey
    }

    var appodealTesting: Bool {
        switch self {
        case .staging:
            return true
        case .testing:
            return true
        case .production:
            return false
        }
    }

    var admobKey: String {
        switch self {
        case .staging:
            return Secrets.stagingAdmobKey // This is the sample unit ID provided by Google for testing
        case .testing:
            return Secrets.stagingAdmobKey // This is the sample unit ID provided by Google for testing
        case .production:
            return Secrets.productionAdmobKey
        }
    }
    
    var admobAdUnitId: String {
        switch self {
        case .staging:
            return Secrets.stagingAdmobUnitID
        case .testing:
            return Secrets.stagingAdmobUnitID
        case .production:
            return Secrets.productionAdmobUnitID
        }
    }
    
    var stripeKey: String {
        switch self {
        case .staging:
            return Secrets.stagingStripeKey
        case .testing:
            return Secrets.stagingStripeKey
        case .production:
            return Secrets.productionStripeKey
        }
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
            UIImage(named: "Onboarding1")!,
            UIImage(named: "Onboarding3")!,
            UIImage(named: "Onboarding2")!
        ]
    }

    static var bgImage: UIImage {
        return #imageLiteral(resourceName: "OnboardingBackground")
    }
}

struct AdvertQuestionType {
    static let Binary = 0
    static let Rating = 1
    static let MultipleChoice = 2
    static let DayOfWeek = 3
    static let Month = 4
    static let Swipe = 5
    static let NumberPicker = 6
    static let TimePicker = 7
    static let DatePicker = 8
    static let URLLinks = 9
}

struct LocationStatusType {
    static let Active = 0
    static let Disabled = 1
    static let AllowCashOut = 2
}

struct AdvertTemplateKey {
    static let imageVideoPortait = "imageVideoPortrait"
    static let imageVideoLandscape = "imageVideoLandscape"
    static let titleImageMessage = "titleImageMessage"
    static let titleMessageImage = "titleMessageImage"
    static let imageTitleMessage = "imageTitleMessage"
}

struct CampaignStatusKey {
    static let availableActive = "availableActive"
    static let availableScheduled = "availableScheduled"
    static let inactive = "inactive"
    static let nonCompliant = "nonCompliant"
    static let nonCompliantScheduled = "nonCompliantScheduled"
    static let prepareToDelete = "prepareToDelete"
    static let deleted = "deleted"
    static let pendingModeration = "pendingModeration"
    static let flagged = "flagged"
}

struct ModeratorStatusKey {
    static let notModerator = "notModerator"
    static let isModerator = "isModerator"
    static let awaitingApproval = "awaitingApproval"
}

struct URLTypes {
    static let website = "website"
    static let facebook = "facebook"
    static let twitter = "twitter"
    static let iOS = "iOS"
    static let android = "android"
    static let onlineStore = "onlineStore"
}

struct AdViewMode {
    static let normal = 1
    static let preview = 2
    static let moderator = 3
}

struct Day {
    static let Mon = 1
    static let Tue = 2
    static let Wed = 4
    static let Thu = 8
    static let Fri = 16
    static let Sat = 32
    static let Sun = 64
}

struct Days {
    static var all: [Int] {
        return [
            Day.Mon,
            Day.Tue,
            Day.Wed,
            Day.Thu,
            Day.Fri,
            Day.Sat,
            Day.Sun
        ]
    }
}
