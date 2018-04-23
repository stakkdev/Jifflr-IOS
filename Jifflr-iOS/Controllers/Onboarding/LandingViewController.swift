//
//  LandingViewController.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 25/01/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit
import TDOnboarding

class LandingViewController: UIViewController, DisplayMessage {

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
                UserDefaultsManager.shared.setAnalytics(on: true)
                UserDefaultsManager.shared.setCrashTracker(on: true)

                self.presentOnboarding()
            }
        } else {
            UserManager.shared.syncUser(completion: { (error) in
                if error == nil {
                    if UserDefaultsManager.shared.onboardingViewed() == true {
                        self.routeBasedOnLocationServices()
                    } else {
                        self.presentOnboarding()
                    }
                } else {
                    UserManager.shared.fetchLocalUser(completion: { (error) in
                        guard error == nil else {
                            self.rootLoginViewController()
                            return
                        }

                        if UserDefaultsManager.shared.onboardingViewed() == true {
                            self.routeBasedOnLocationServices()
                        } else {
                            self.presentOnboarding()
                        }
                    })
                }
            })
        }
    }

    func presentOnboarding() {
        let onboarding = TDOnboarding(titles: Onboarding.titles, subTitles: Onboarding.subTitles, images: Onboarding.images, backgroundImage: Onboarding.bgImage, options: OnboardingCustomizable())
        onboarding.delegate = self
        onboarding.presentOnboardingVC(from: self, animated: true)
    }

    func routeBasedOnLocationServices() {
        if LocationManager.shared.locationServicesEnabled() == true {
            
            LocationManager.shared.fetchLocalLocation()
            if Reachability.isConnectedToNetwork() {
                LocationManager.shared.getCurrentLocation()
            }
            
            self.rootDashboardViewController()
        } else {
            self.rootLocationRequiredViewController()
        }
    }
}

extension LandingViewController: TDOnboardingDelegate {
    func onboardingShouldComplete() {
        UserDefaultsManager.shared.setOnboardingViewed()

        if Session.shared.currentUser == nil {
            self.rootLoginViewController()
        } else {
            self.routeBasedOnLocationServices()
        }
    }

    func onboardingShouldSkip() {
        if Session.shared.currentUser == nil {
            self.rootLoginViewController()
        } else {
            self.routeBasedOnLocationServices()
        }
    }
}
