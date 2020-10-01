//
//  ViewControllerExtensions.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 25/01/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit

extension UIViewController {
    func rootLoginViewController() {
        let loginVC = LoginViewController.instantiateFromStoryboard()
        let navVC = UINavigationController(rootViewController: loginVC)
        navVC.isNavigationBarHidden = false

        self.set(root: navVC)
    }

    func rootLocationRequiredViewController() {
        let loginVC = LocationRequiredViewController.instantiateFromStoryboard()
        let navVC = UINavigationController(rootViewController: loginVC)
        navVC.isNavigationBarHidden = false

        self.set(root: navVC)
    }
    
    func rootAdTrackingViewController() {
        let loginVC = AdTrackingViewController.instantiateFromStoryboard()
        let navVC = UINavigationController(rootViewController: loginVC)
        navVC.isNavigationBarHidden = false

        self.set(root: navVC)
    }

    func rootDashboardViewController(animated: Bool = true) {
        let dashboardVC = DashboardViewController.instantiateFromStoryboard()
        let navVC = UINavigationController(rootViewController: dashboardVC)
        navVC.isNavigationBarHidden = true
        
        if animated {
            self.set(root: navVC)
        } else {
            let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate //swiftlint:disable:this force_cast
            appDelegate.window!.rootViewController = navVC
        }
    }

    func set(root viewController: UIViewController) {
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate //swiftlint:disable:this force_cast
        if let window = UIApplication.shared.keyWindow, let rootViewController = window.rootViewController {
            viewController.view.frame = rootViewController.view.frame
            viewController.view.layoutIfNeeded()

            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
                window.rootViewController = viewController
            }, completion: { _ in
                // May be do something :_?
            })
        } else {
            appDelegate.window!.rootViewController = viewController
        }
    }

    func requestGoToAppSettings(confirm: (() -> Void)?, cancel: (() -> Void)?) {
        let application = UIApplication.shared
        let alertVC = UIAlertController(title: "alert.notifications.title".localized(), message: "alert.notifications.message".localized(), preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "alert.notifications.cancelButton".localized(), style: .cancel) { _ in
            cancel?()
        }

        let confirmAction = UIAlertAction(title: "alert.notifications.goToSettingsButton".localized(), style: .default) { _ in
            if let settingsURL = URL(string: UIApplicationOpenSettingsURLString), application.canOpenURL(settingsURL) {
                application.open(settingsURL, options: [:], completionHandler: nil)
            }
            confirm?()
        }

        alertVC.addAction(cancelAction)
        alertVC.addAction(confirmAction)
        self.present(alertVC, animated: true, completion: nil)
    }
}
