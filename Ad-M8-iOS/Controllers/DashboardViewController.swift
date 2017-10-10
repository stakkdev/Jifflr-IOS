//
//  DashboardViewController.swift
//  Ad-M8-iOS
//
//  Created by James Shaw on 10/10/2017.
//  Copyright © 2017 The Distance. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {

    class func presentAsRootViewController() {
        let navigationController = UINavigationController()
        navigationController.viewControllers = [self.instantiateFromStoryboard()]
        navigationController.setNavigationBarHidden(false, animated: false)
        UIApplication.shared.delegate?.window??.rootViewController = navigationController
    }

    class func instantiateFromStoryboard() -> DashboardViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Ad-M8"
    }
}
