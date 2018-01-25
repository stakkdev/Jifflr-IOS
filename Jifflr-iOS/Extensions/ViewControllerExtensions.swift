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
        navVC.isNavigationBarHidden = true

        self.set(root: navVC)
    }

    func rootDashboardViewController() {
        let dashboardVC = DashboardViewController.instantiateFromStoryboard()
        let navVC = UINavigationController(rootViewController: dashboardVC)
        navVC.isNavigationBarHidden = true

        self.set(root: navVC)
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
}
