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

    public var failureTitle: String {
        switch self {
        case .noInternetConnection:
            return NSLocalizedString("Error - No internet connection.", comment: "")
        }
    }

    public var failureDescription: String {
        switch self {
        case .noInternetConnection:
            return NSLocalizedString("Please check your internet connection and try again.", comment: "")
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
