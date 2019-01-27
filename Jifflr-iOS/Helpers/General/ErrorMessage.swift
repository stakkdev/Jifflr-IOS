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
    case loginNotRegistered
    case cashoutFailedInternet
    case maxCampaignsLimitReached
    case budgetLessThanAdSubmissionFee
    case updateCampaignContent(String)

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
        case .loginNotRegistered:
            return "error.loginNotRegistered.title".localized()
        case .loginWrongPassword:
            return "error.loginWrongPassword.title".localized()
        default:
            return "error.title".localized()
        }
    }

    public var failureDescription: String {
        switch self {
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
