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
    case pendingUsersFailed
    case contactsAccessFailed
    case inviteAlreadySent
    case inviteSendFailed
    case feedbackSaveFailed
    case locationNotSupported
    case cashoutFetchFailed
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

    public var failureTitle: String {
        return "error.title".localized()
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
        case .locationFailed:
            return "Unable to fetch location. Please check your internet connection and try again."
        case .unknown:
            return "An unknown error occured."
        case .pendingUsersFailed:
            return "Unable to fetch pending users. Please check your internet connection and try again."
        case .contactsAccessFailed:
            return "Unable to access contacts. Please allow Ad-M8 access to your contacts through the Settings app."
        case .inviteAlreadySent:
            return "An invite has already been sent to this email address."
        case .inviteSendFailed:
            return "Unable to send invite. Please check your internet connection and try again."
        case .feedbackSaveFailed:
            return "Unable to save advert feedback. Please check your internet connection and try again."
        case .locationNotSupported:
            return "You're location is not supported."
        case .cashoutFetchFailed:
            return "Unable to fetch cashouts. Please check your internet connection and try again."
        }
    }
}

public enum AlertMessage {
    case resetEmailSent
    case noInternetConnection

    public var title: String {
        switch self {
        case .resetEmailSent:
            return "alert.resetEmailSent.title".localized()
        case .noInternetConnection:
            return "alert.noInternetConnection.title".localized()
        }
    }

    public var message: String {
        switch self {
        case .resetEmailSent:
            return "alert.resetEmailSent.message".localized()
        case .noInternetConnection:
            return "alert.noInternetConnection.message".localized()
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
