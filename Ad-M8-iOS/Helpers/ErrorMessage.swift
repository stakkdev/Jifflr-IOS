//
//  ErrorMessage.swift
//  Ad-M8-iOS
//
//  Created by James Shaw on 09/10/2017.
//  Copyright © 2017 The Distance. All rights reserved.
//

import Foundation
import UIKit

public enum ErrorMessage {
    case noInternetConnection
    case parseError(String)
    case signUpFailed
    case loginFailed
    case unknown

    public var failureTitle: String {
        return "Error"
    }

    public var failureDescription: String {
        switch self {
        case .noInternetConnection:
            return "Please check your internet connection and try again."
        case .parseError(let details):
            return "An error occured: \(details)"
        case .signUpFailed:
            return "Unable to sign-up. Please check your internet connection and try again."
        case .loginFailed:
            return "Unable to sign-up. Please check your internet connection and try again."
        case .unknown:
            return "An unknown error occured."
        }
    }
}

protocol DisplayMessage {
    func displayMessage(title: String, message: String, dismissText: String?, dismissAction: ((UIAlertAction) -> Void)?)
}


extension DisplayMessage {

    func displayMessage(title: String, message: String, dismissText: String? = nil, dismissAction: ((UIAlertAction) -> Void)? = nil) {

        let defaultDismissText = NSLocalizedString("Dismiss", comment: "")

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
}
