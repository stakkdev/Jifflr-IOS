//
//  ErrorMessage.swift
//  Ad-M8-iOS
//
//  Created by James Shaw on 09/10/2017.
//  Copyright © 2017 The Distance. All rights reserved.
//

import Foundation
import UIKit
import Localize_Swift
import Firebase
import FirebaseInstanceID

public enum ErrorMessage {
    case parseError(String)
    case userAlreadyExists
    case loginFailed
    case loginWrongPassword
    case locationFailed
    case unknown
    case contactsAccessFailed
    case inviteAlreadySent
    case inviteSendFailed
    case resetPasswordFailed
    case invalidField(String)
    case invalidProfileField(String)
    case invalidPassword
    case invalidDob
    case invalidGender
    case invalidProfileGender
    case invalidTermsAndConditions
    case faqsFailed
    case noInternetConnection
    case invalidCurrentPassword
    case invalidNewPassword
    case invalidInvitationCode
    case invalidInvitationCodeRegistration
    case contactsNoEmail
    case cashoutFailed
    case invalidPayPalEmail
    case invalidCashoutPassword
    case paypalEmailSaveFailed
    case admobFetchFailed
    case advertisingTurnedOff
    case advertFetchFailed
    case invalidDobProfile
    case invalidFeedback(Int)
    case blockedCountry
    case changeInvitationName
    case changeInvitationEmail
    case createAdName
    case chooseTemplate
    case templateFetchFailed
    case addContent
    case mediaSaveFailed
    case flagAdFailed
    case fetchAnswersFailed
    case saveAdFailed
    case adBuilderOverviewFetchFailed
    case questionTypeFetchFailed
    case locationFetchFailed
    case languageFetchFailed
    case genderFetchFailed
    case withdrawalValidationFailed
    case withdrawalFailed
    case withdrawalEmail
    case increaseBudgetFailed
    case increaseBudgetFailedFromServer
    case getCampaignResultsFailed
    case copyCampaignFailed
    case minTopUpAmount
    case paypalTopUpFailed
    case nonCompliantActivate
    case activationFailedInsufficientBalance
    case campaignActivationFailed
    case campaignActivationFailedInvalidBalance
    case decreaseBudget
    case applyModerator
    case applyModeratorFailedServer
    case moderationValidation
    case moderationSubmitFailed
    case noAdsToModerate
    case invalidAnswersRequired
    case NoInternetConnectionRegistration
    case addEmailInvalid
    case addContactInvalid
    case loginNotRegistered
    case cashoutFailedInternet
    case maxCampaignsLimitReached
    case budgetLessThanAdSubmissionFee
    case updateCampaignContent(String)
    case videoTooLong
    case minCashoutAmount(String)
    case teamUpdating
    case expiredActivateCampaign

    public var failureTitle: String {
        switch self {
        case .invalidInvitationCodeRegistration:
            return "error.invalidInvitationCodeRegistration.title".localized()
        case .NoInternetConnectionRegistration:
            return "error.noInternetConnectionRegistration.title".localized()
        case .userAlreadyExists:
            return "error.register.userAlreadyExists.title".localized()
        case .invalidField(let details):
            return "error.register.invalidField.title".localizedFormat(details)
        case .addEmailInvalid:
            return "addEmail.error.title".localized()
        case .addContactInvalid:
            return "addContact.error.title".localized()
        case .loginNotRegistered:
            return "error.loginNotRegistered.title".localized()
        case .loginWrongPassword:
            return "error.loginWrongPassword.title".localized()
        case .teamUpdating:
            return "error.teamUpdating.title".localized()
        default:
            return "error.title".localized()
        }
    }

    public var failureDescription: String {
        switch self {
        case .addContactInvalid:
            return "addContact.error.message".localized()
        case .parseError(let details):
            return "An error occured: \(details)"
        case .invalidField(let details):
            return "error.register.invalidField".localizedFormat(details)
        case .invalidProfileField(let details):
            return "error.register.invalidField".localizedFormat(details)
        case .invalidPassword:
            return "error.register.invalidPassword".localized()
        case .invalidDob:
            return "error.register.invalidDob".localized()
        case .invalidGender:
            return "error.register.invalidGender".localized()
        case .invalidProfileGender:
            return "error.profile.invalidGender".localized()
        case .invalidTermsAndConditions:
            return "error.register.termsAndConditions".localized()
        case .userAlreadyExists:
            return "error.register.userAlreadyExists".localized()
        case .loginFailed:
            return "error.login.message".localized()
        case .loginWrongPassword:
            return "error.loginWrongPassword.message".localized()
        case .resetPasswordFailed:
            return "error.resetPassword.message".localized()
        case .faqsFailed:
            return "error.faqs.message".localized()
        case .noInternetConnection:
            return "error.noInternetConnection".localized()
        case .invalidCurrentPassword:
            return "error.invalidCurrentPassword".localized()
        case .invalidNewPassword:
            return "error.invalidNewPassword".localized()
        case .invalidInvitationCode:
            return "error.invalidInvitationCode".localized()
        case .invalidInvitationCodeRegistration:
            return "error.invalidInvitationCodeRegistration.message".localized()
        case .contactsAccessFailed:
            return "error.contactsAccessFailed".localized()
        case .contactsNoEmail:
            return "error.contactsNoEmail".localized()
        case .locationFailed:
            return "error.locationFailed".localized()
        case .unknown:
            return "error.unknown".localized()
        case .inviteAlreadySent:
            return "error.inviteAlreadySent".localized()
        case .inviteSendFailed:
            return "error.inviteSendFailed".localized()
        case .cashoutFailed:
            return "error.cashoutFailed".localized()
        case .cashoutFailedInternet:
            return "error.cashoutFailedInternet".localized()
        case .invalidPayPalEmail:
            return "error.invalidPayPalEmail".localized()
        case .invalidCashoutPassword:
            return "error.invalidCashoutPassword".localized()
        case .paypalEmailSaveFailed:
            return "error.paypalEmailSaveFailed".localized()
        case .admobFetchFailed:
            return "error.admobFetchFailed".localized()
        case .advertFetchFailed:
            return "error.advertFetchFailed".localized()
        case .invalidDobProfile:
            return "error.profile.invalidDob".localized()
        case .invalidFeedback(let value):
            return "error.invalidFeedback".localizedFormat(value)
        case .blockedCountry:
            return "error.blockedCountry".localized()
        case .changeInvitationName:
            return "error.changeInvitation.invalidName".localized()
        case .changeInvitationEmail:
            return "error.changeInvitation.invalidEmail".localized()
        case .createAdName:
            return "error.createAd.adName".localized()
        case .chooseTemplate:
            return "error.chooseTemplate".localized()
        case .templateFetchFailed:
            return "error.templateFetchFailed".localized()
        case .addContent:
            return "error.addContent".localized()
        case .mediaSaveFailed:
            return "error.mediaSaveFailed".localized()
        case .flagAdFailed:
            return "error.flagAdFailed".localized()
        case .fetchAnswersFailed:
            return "error.addQuestionsFetchAnswers".localized()
        case .saveAdFailed:
            return "error.saveAd".localized()
        case .adBuilderOverviewFetchFailed:
            return "error.adBuilderOverviewFetchFailed".localized()
        case .questionTypeFetchFailed:
            return "error.questionTypeFetchFailed".localized()
        case .locationFetchFailed:
            return "error.locationFetchFailed".localized()
        case .languageFetchFailed:
            return "error.languageFetchFailed".localized()
        case .genderFetchFailed:
            return "error.genderFetchFailed".localized()
        case .withdrawalValidationFailed:
            return "error.withdrawalValidationFailed".localized()
        case .withdrawalFailed:
            return "error.withdrawalFailed".localized()
        case .withdrawalEmail:
            return "error.withdrawalEmail".localized()
        case .increaseBudgetFailed:
            return "error.increaseBudgetFailed".localized()
        case .increaseBudgetFailedFromServer:
            return "error.increaseBudgetFailedFromServer".localized()
        case .getCampaignResultsFailed:
            return "error.getCampaignResultsFailed".localized()
        case .copyCampaignFailed:
            return "error.copyCampaignFailed".localized()
        case .minTopUpAmount:
            return "error.minTopUpAmount".localizedFormat(Session.shared.currentCurrencySymbol)
        case .paypalTopUpFailed:
            return "error.paypalTopUpFailed".localized()
        case .nonCompliantActivate:
            return "error.nonCompliantActivate".localized()
        case .activationFailedInsufficientBalance:
            return "error.activationFailedInsufficientBalance".localized()
        case .campaignActivationFailed:
            return "error.campaignActivationFailed".localized()
        case .campaignActivationFailedInvalidBalance:
            return "error.campaignActivationFailedInvalidBalance".localized()
        case .decreaseBudget:
            return "error.decreaseBudget".localized()
        case .applyModerator:
            return "error.applyModerator.termsAndConditions".localized()
        case .applyModeratorFailedServer:
            return "error.applyModeratorServer".localized()
        case .moderationValidation:
            return "error.moderationValidation".localized()
        case .moderationSubmitFailed:
            return "error.moderationSubmitFailed".localized()
        case .noAdsToModerate:
            return "error.noAdsToModerate".localized()
        case .invalidAnswersRequired:
            return "error.invalidAnswersRequired".localized()
        case .NoInternetConnectionRegistration:
            return "error.noInternetConnectionRegistration.message".localized()
        case .addEmailInvalid:
            return "addEmail.error.message".localized()
        case .loginNotRegistered:
            return "error.loginNotRegistered.message".localized()
        case .maxCampaignsLimitReached:
            return "error.maxCampaignsLimitReached.message".localized()
        case .budgetLessThanAdSubmissionFee:
            return "error.budgetLessThanAdSubmissionFee.message".localized()
        case .updateCampaignContent(let amount):
            return "error.updateCampaignContent.message".localizedFormat(amount)
        case .videoTooLong:
            return "error.videoTooLong.message".localized()
        case .minCashoutAmount(let amount):
            return "error.minCashoutAmount.message".localizedFormat(amount)
        case .teamUpdating:
            return "error.teamUpdating.message".localized()
        case .expiredActivateCampaign:
            return "error.expiredActivateCampaign.message".localized()
        case .advertisingTurnedOff:
            return "error.advertisingTurnedOff.message".localized()
        }
    }
}

public enum AlertMessage {
    case resetEmailSent
    case noInternetConnection
    case teamChanged
    case inviteSent(String)
    case cashoutSuccess
    case changeTeam
    case leaveTeam
    case withdrawalSuccess
    case increaseBudgetSuccess
    case campaignResultsSuccess
    case paypalTopUpSuccess
    case scheduledDeleteCampaign
    case campaignCopied
    case applyModerator
    case feedbackSubmitted
    case flagAdSuccess
    case campaignUpdated

    public var title: String {
        switch self {
        case .resetEmailSent:
            return "alert.resetEmailSent.title".localized()
        case .noInternetConnection:
            return "alert.noInternetConnection.title".localized()
        case .teamChanged:
            return "alert.teamChanged.title".localized()
        case .inviteSent:
            return "alert.inviteSent.title".localized()
        case .cashoutSuccess:
            return "alert.cashoutSuccess.title".localized()
        case .changeTeam:
            return "alert.changeTeam.title".localized()
        case .leaveTeam:
            return "alert.leaveTeam.title".localized()
        case .withdrawalSuccess:
            return "alert.withdrawalSuccess.title".localized()
        case .increaseBudgetSuccess:
            return "alert.increaseBudgetSuccess.title".localized()
        case .campaignResultsSuccess:
            return "alert.campaignResultsSuccess.title".localized()
        case .paypalTopUpSuccess:
            return "alert.paypalTopUpSuccess.title".localized()
        case .scheduledDeleteCampaign:
            return "alert.scheduledDeleteCampaign.title".localized()
        case .campaignCopied:
            return "alert.campaignCopied.title".localized()
        case .applyModerator:
            return "alert.applyModerator.title".localized()
        case .feedbackSubmitted:
            return "alert.feedbackSubmitted.title".localized()
        case .flagAdSuccess:
            return "alert.flagAdSuccess.title".localized()
        case .campaignUpdated:
            return "alert.campaignUpdated.title".localized()
        }
    }

    public var message: String {
        switch self {
        case .resetEmailSent:
            return "alert.resetEmailSent.message".localized()
        case .noInternetConnection:
            return "alert.noInternetConnection.message".localized()
        case .teamChanged:
            return "alert.teamChanged.message".localized()
        case .inviteSent(let name):
            return "alert.inviteSent.message".localizedFormat(name)
        case .cashoutSuccess:
            return "alert.cashoutSuccess.message".localized()
        case .changeTeam:
            return "alert.changeTeam.message".localized()
        case .leaveTeam:
            return "alert.leaveTeam.message".localized()
        case .withdrawalSuccess:
            return "alert.withdrawalSuccess.message".localized()
        case .increaseBudgetSuccess:
            return "alert.increaseBudgetSuccess.message".localized()
        case .campaignResultsSuccess:
            return "alert.campaignResultsSuccess.message".localized()
        case .paypalTopUpSuccess:
            return "alert.paypalTopUpSuccess.message".localized()
        case .scheduledDeleteCampaign:
            return "alert.scheduledDeleteCampaign.message".localized()
        case .campaignCopied:
            return "alert.campaignCopied.message".localized()
        case .applyModerator:
            return "alert.applyModerator.message".localized()
        case .feedbackSubmitted:
            return "alert.feedbackSubmitted.message".localized()
        case .flagAdSuccess:
            return "alert.flagAdSuccess.message".localized()
        case .campaignUpdated:
            return "alert.campaignUpdated.message".localized()
        }
    }
}

protocol DisplayMessage {
    func displayMessage(title: String, message: String, dismissText: String?, dismissAction: ((UIAlertAction) -> Void)?)
    func displayError(error: ErrorMessage?)
}


extension DisplayMessage {
    func displayMessage(title: String, message: String, dismissText: String? = nil, dismissAction: ((UIAlertAction) -> Void)? = nil) {

        let defaultDismissText = "error.dismiss".localized()

        if let viewController = self as? UIViewController {

            if let _ = viewController.presentedViewController as? UIAlertController {
                return
            }

            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let dismissAction = UIAlertAction(title: dismissText ?? defaultDismissText, style: .cancel, handler: dismissAction)
            alert.addAction(dismissAction)
            viewController.present(alert, animated: true, completion: nil)
        }
    }

    func displayError(error: ErrorMessage?) {

        var theError = error
        if theError == nil {
            theError = ErrorMessage.unknown
        }
        
        self.logError(error: theError!)

        let defaultDismissText = "error.dismiss".localized()

        if let viewController = self as? UIViewController {

            if let _ = viewController.presentedViewController as? UIAlertController {
                return
            }

            let alert = UIAlertController(title: theError!.failureTitle, message: theError!.failureDescription, preferredStyle: .alert)
            let dismissAction = UIAlertAction(title: defaultDismissText, style: .cancel, handler: nil)
            alert.addAction(dismissAction)
            viewController.present(alert, animated: true, completion: nil)
        }
    }
}

extension DisplayMessage {
    func logError(error: ErrorMessage) {
      var screenName = ""
      if let vc = UIApplication.topViewController() {
         screenName = String(describing: vc)
      }
      let appVersionString = Bundle.main.appVersion
      let appBuildString = Bundle.main.appBuild
      let environmentString = Constants.currentEnvironment.rawValue
      let appVersionAndBuild = "Version \(appVersionString ?? "N/A") (\(appBuildString ?? "N/A")) \(environmentString)"
      
      if let userId = Session.shared.currentUser?.objectId {
        Crashlytics.crashlytics().setUserID(userId)
      }
      
      Crashlytics.crashlytics().setCustomValue("errorTitle", forKey: error.failureTitle)
      Crashlytics.crashlytics().setCustomValue("errorDescription", forKey: error.failureDescription)
      Crashlytics.crashlytics().setCustomValue("screen", forKey: screenName)
      Crashlytics.crashlytics().setCustomValue("device", forKey: UIDevice.current.deviceModelReadable)
      Crashlytics.crashlytics().setCustomValue("os", forKey: UIDevice.current.systemVersionReadable)
      Crashlytics.crashlytics().setCustomValue("version", forKey: appVersionAndBuild)
    }
}

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}

extension UIDevice {
  enum ScreenSize {
    case iphone5
    case iphone6
    case iphone6Plus
    case iphoneX
    case iphoneXSMax
    case notConfigured
  }

  public var deviceType: DeviceType {
    return DeviceType.current
  }

  var deviceModelReadable: String {
    return self.deviceType.displayName
  }

  var systemVersionReadable: String {
    return "iOS \(self.systemVersion)"
  }

  var screenSize: ScreenSize {
    switch self.userInterfaceIdiom {
    case .phone:
      switch UIScreen.main.bounds.height {
      case 896:
        return .iphoneXSMax
      case 812:
        return .iphoneX
      case 736:
        return .iphone6Plus
      case 667:
        return .iphone6
      case 568:
        return .iphone5
      default:
        return .notConfigured
      }
    default:
      return .notConfigured
    }
  }

  var isiPhone6OrSmaller: Bool {
    return self.screenSize == .iphone6 || self.isSmallScreen
  }

  var isiPhone6PlusOrSmaller: Bool {
    return self.screenSize == .iphone6Plus || self.isiPhone6OrSmaller
  }

  var isSmallScreen: Bool {
    return self.screenSize == .iphone5
  }

  var isiPhoneX: Bool {
    return self.screenSize == .iphoneX
  }
}

public enum DeviceType: String, CaseIterable {
    case iPhone2G

    case iPhone3G
    case iPhone3GS

    case iPhone4
    case iPhone4S

    case iPhone5
    case iPhone5C
    case iPhone5S

    case iPhone6
    case iPhone6Plus

    case iPhone6S
    case iPhone6SPlus

    case iPhoneSE

    case iPhone7
    case iPhone7Plus

    case iPhone8
    case iPhone8Plus

    case iPhoneX

    case iPhoneXS
    case iPhoneXSMax
    case iPhoneXR

    case iPodTouch1G
    case iPodTouch2G
    case iPodTouch3G
    case iPodTouch4G
    case iPodTouch5G
    case iPodTouch6G

    case iPad
    case iPad2
    case iPad3
    case iPad4
    case iPad5
    case iPad6
    case iPadMini
    case iPadMiniRetina
    case iPadMini3
    case iPadMini4

    case iPadAir
    case iPadAir2

    case iPadPro9Inch
    case iPadPro10p5Inch
    case iPadPro11Inch
    case iPadPro12Inch

    case simulator
    case notAvailable

    // MARK: Constants
    /// The current device type
    public static var current: DeviceType {

      var systemInfo = utsname()
      uname(&systemInfo)

      let machine = systemInfo.machine
      let mirror = Mirror(reflecting: machine)
      var identifier = ""

      for child in mirror.children {
        if let value = child.value as? Int8, value != 0 {
          identifier.append(String(UnicodeScalar(UInt8(value))))
        }
      }

      return DeviceType(identifier: identifier)
    }

    // MARK: Variables
    /// The display name of the device type
    public var displayName: String {

      switch self {
      case .iPhone2G: return "iPhone 2G"
      case .iPhone3G: return "iPhone 3G"
      case .iPhone3GS: return "iPhone 3GS"
      case .iPhone4: return "iPhone 4"
      case .iPhone4S: return "iPhone 4S"
      case .iPhone5: return "iPhone 5"
      case .iPhone5C: return "iPhone 5C"
      case .iPhone5S: return "iPhone 5S"
      case .iPhone6Plus: return "iPhone 6 Plus"
      case .iPhone6: return "iPhone 6"
      case .iPhone6S: return "iPhone 6S"
      case .iPhone6SPlus: return "iPhone 6S Plus"
      case .iPhoneSE: return "iPhone SE"
      case .iPhone7: return "iPhone 7"
      case .iPhone7Plus: return "iPhone 7 Plus"
      case .iPhone8: return "iPhone 8"
      case .iPhone8Plus: return "iPhone 8 Plus"
      case .iPhoneX: return "iPhone X"
      case .iPhoneXS: return "iPhone XS"
      case .iPhoneXSMax: return "iPhone XS Max"
      case .iPhoneXR: return "iPhone XR"
      case .iPodTouch1G: return "iPod Touch 1G"
      case .iPodTouch2G: return "iPod Touch 2G"
      case .iPodTouch3G: return "iPod Touch 3G"
      case .iPodTouch4G: return "iPod Touch 4G"
      case .iPodTouch5G: return "iPod Touch 5G"
      case .iPodTouch6G: return "iPod Touch 6G"
      case .iPad: return "iPad"
      case .iPad2: return "iPad 2"
      case .iPad3: return "iPad 3"
      case .iPad4: return "iPad 4"
      case .iPad5: return "iPad 5"
      case .iPad6: return "iPad 6"
      case .iPadMini: return "iPad Mini"
      case .iPadMiniRetina: return "iPad Mini Retina"
      case .iPadMini3: return "iPad Mini 3"
      case .iPadMini4: return "iPad Mini 4"
      case .iPadAir: return "iPad Air"
      case .iPadAir2: return "iPad Air 2"
      case .iPadPro9Inch: return "iPad Pro 9 Inch"
      case .iPadPro10p5Inch: return "iPad Pro 10.5 Inch"
      case .iPadPro11Inch: return "iPad Pro 11 Inch"
      case .iPadPro12Inch: return "iPad Pro 12 Inch"
      case .simulator: return "Simulator"
      case .notAvailable: return "Not Available"
      }
    }

    /// The identifiers associated with each device type
    internal var identifiers: [String] {

      switch self {
      case .notAvailable: return []
      case .simulator: return ["i386", "x86_64"]

      case .iPhone2G: return ["iPhone1,1"]
      case .iPhone3G: return ["iPhone1,2"]
      case .iPhone3GS: return ["iPhone2,1"]
      case .iPhone4: return ["iPhone3,1", "iPhone3,2", "iPhone3,3"]
      case .iPhone4S: return ["iPhone4,1"]
      case .iPhone5: return ["iPhone5,1", "iPhone5,2"]
      case .iPhone5C: return ["iPhone5,3", "iPhone5,4"]
      case .iPhone5S: return ["iPhone6,1", "iPhone6,2"]
      case .iPhone6: return ["iPhone7,2"]
      case .iPhone6Plus: return ["iPhone7,1"]
      case .iPhone6S: return ["iPhone8,1"]
      case .iPhone6SPlus: return ["iPhone8,2"]
      case .iPhoneSE: return ["iPhone8,4"]
      case .iPhone7: return ["iPhone9,1", "iPhone9,3"]
      case .iPhone7Plus: return ["iPhone9,2", "iPhone9,4"]
      case .iPhone8: return ["iPhone10,1", "iPhone10,4"]
      case .iPhone8Plus: return ["iPhone10,2", "iPhone10,5"]
      case .iPhoneX: return ["iPhone10,3", "iPhone10,6"]
      case .iPhoneXS: return ["iPhone11,2"]
      case .iPhoneXSMax: return ["iPhone11,4", "iPhone11,6"]
      case .iPhoneXR: return ["iPhone11,8"]

      case .iPodTouch1G: return ["iPod1,1"]
      case .iPodTouch2G: return ["iPod2,1"]
      case .iPodTouch3G: return ["iPod3,1"]
      case .iPodTouch4G: return ["iPod4,1"]
      case .iPodTouch5G: return ["iPod5,1"]
      case .iPodTouch6G: return ["iPod7,1"]

      case .iPad: return ["iPad1,1", "iPad1,2"]
      case .iPad2: return ["iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4"]
      case .iPad3: return ["iPad3,1", "iPad3,2", "iPad3,3"]
      case .iPad4: return ["iPad3,4", "iPad3,5", "iPad3,6"]
      case .iPad5: return ["iPad6,11", "iPad6,12"]
      case .iPad6: return ["iPad7,5", "iPad7,6"]
      case .iPadMini: return ["iPad2,5", "iPad2,6", "iPad2,7"]
      case .iPadMiniRetina: return ["iPad4,4", "iPad4,5", "iPad4,6"]
      case .iPadMini3: return ["iPad4,7", "iPad4,8", "iPad4,9"]
      case .iPadMini4: return ["iPad5,1", "iPad5,2"]
      case .iPadAir: return ["iPad4,1", "iPad4,2", "iPad4,3"]
      case .iPadAir2: return ["iPad5,3", "iPad5,4"]
      case .iPadPro9Inch: return ["iPad6,3", "iPad6,4"]
      case .iPadPro10p5Inch: return ["iPad7,3", "iPad7,4"]
      case .iPadPro11Inch: return ["iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4"]
      case .iPadPro12Inch: return ["iPad6,7", "iPad6,8", "iPad7,1", "iPad7,2", "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8"]
      }
    }

    // MARK: Inits
    /// Creates a device type
    ///
    /// - Parameter identifier: The identifier of the device
    internal init(identifier: String) {
      for device in DeviceType.allCases {
        for deviceId in device.identifiers {
          guard identifier == deviceId else { continue }
          self = device
          return
        }
      }

      self = .notAvailable
    }
}
