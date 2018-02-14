//
//  LandingViewController.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 25/01/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit
import TDOnboarding

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
            if UserDefaultsManager.shared.onboardingViewed() == true {
                self.rootLoginViewController()
            } else {
                let onboarding = TDOnboarding(titles: Onboarding.titles, subTitles: Onboarding.subTitles, images: Onboarding.images, backgroundImage: Onboarding.bgImage, options: OnboardingCustomizable())
                onboarding.delegate = self
                onboarding.presentOnboardingVC(from: self, animated: true)
            }
        } else {
            if LocationManager.shared.locationServicesEnabled() == true {
                self.rootDashboardViewController()
            } else {
                self.rootLocationRequiredViewController()
            }
        }
    }
}

extension LandingViewController: TDOnboardingDelegate {
    func onboardingShouldSkip() {
        UserDefaultsManager.shared.setOnboardingViewed()
        self.rootLoginViewController()
    }
}
