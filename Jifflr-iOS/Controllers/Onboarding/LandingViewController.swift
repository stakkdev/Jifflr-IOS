//
//  LandingViewController.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 25/01/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit

class LandingViewController: UIViewController {

    class func instantiateFromStoryboard() -> LandingViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "LandingViewController") as! LandingViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.determineAppRoute()
    }

    func determineAppRoute() {
        if Session.shared.currentUser == nil {
            self.rootLoginViewController()
        } else {
            self.rootDashboardViewController()
        }
    }
}
