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

public enum ErrorMessage {
    case parseError(String)
    case userAlreadyExists
    case loginFailed
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
    case advertFetchFailed
    case invalidDobProfile
    case invalidFeedback
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

    public var failureTitle: String {
        switch self {
        case .invalidInvitationCodeRegistration:
            return "error.invalidInvitationCodeRegistration.title".localized()
        default:
            return "error.title".localized()
        }
    }

    public var failureDescription: String {
        switch self {
        case .parseError(let details):
            return "An error occured: \(details)"
        case .invalidField(let details):
            return "\("error.register.invalidField".localized()) \(details)"
        case .invalidProfileField(let details):
            return "\("error.profile.invalidField".localized()) \(details)"
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
        case .invalidFeedback:
            return "error.invalidFeedback".localized()
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
