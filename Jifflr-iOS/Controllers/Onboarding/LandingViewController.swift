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
        let items: [TDOnboardingItem] = Onboarding.titles.enumerated().map {
            let image = Onboarding.images[$0.offset]
            let subtitleParagraphStyle = NSMutableParagraphStyle()
            subtitleParagraphStyle.lineSpacing = 19.0
            subtitleParagraphStyle.alignment = .center

            let subtitleAttributes: [NSAttributedStringKey: Any] = [
                .font: UIFont(name: Constants.FontNames.GothamBook, size: 13.5)!,
                .foregroundColor: UIColor.mainBlue,
                .paragraphStyle: subtitleParagraphStyle
            ]
            let subtitle = NSAttributedString(string: Onboarding.subTitles[$0.offset], attributes: subtitleAttributes)
            let titleAttributes: [NSAttributedStringKey: Any] = [
                .font: UIFont(name: Constants.FontNames.GothamBold, size: 18.0)!,
                .foregroundColor: UIColor.mainBlue
            ]
            let title = NSAttributedString(string: $0.element, attributes: titleAttributes)

            let actionButtonAttributes: [NSAttributedStringKey: Any] = [
                .font: UIFont(name: Constants.FontNames.GothamBook, size: 16.0)!,
                .foregroundColor: UIColor.white
            ]
            let actionButtonTitle = $0.offset == Onboarding.titles.count - 1 ? "onboarding.closeButton".localized() : "onboarding.skipButton".localized()
            let actionButtonAttributedTitle = NSAttributedString(string: actionButtonTitle, attributes: actionButtonAttributes)
            
            return JifflrOnboardingItem(image: image, subtitle: subtitle, bottomTitle: title, topActionButtonTitle: actionButtonAttributedTitle)
        }
        
        let onboarding = TDOnboarding(items: items, options: JifflrOnboardingOptions())
        onboarding.delegate = self
        onboarding.present(from: self, completion: nil)
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
    func topActionButtonTapped(on onboarding: TDOnboarding, itemIndex: Int) {
        if itemIndex == Onboarding.titles.count - 1 {
            UserDefaultsManager.shared.setOnboardingViewed()
        }

        if Session.shared.currentUser == nil {
            self.rootLoginViewController()
        } else {
            self.routeBasedOnLocationServices()
        }
    }
    
    func bottomActionButtonTapped(on onboarding: TDOnboarding, itemIndex: Int) {
    }
}

struct JifflrOnboardingOptions: TDOnboardingOptions {
    var defaultBackgroundImage: UIImage {
        return Onboarding.bgImage
    }
    
    var statusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    func color(for component: TDOnboardingColorizableComponent) -> UIColor? {
        switch component {
        case .paginationItem:
            return UIColor.mainBlue
        case .bottomPanel:
            return UIColor.white
        case .backgroundImageOverlay:
            return UIColor.clear
        }
    }

    func measure(for component: TDOnboardingMeasurableComponent) -> CGFloat? {
        switch component {
        case .bottomPanelHeight:
            return 250
        case .imageTopDistance:
            return 10.0
        case .imageBottomDistance:
            return 10.0
        default:
            return nil
        }
    }
}

struct JifflrOnboardingItem: TDOnboardingItem {
    var image: UIImage
    var subtitle: NSAttributedString
    var topTitle: NSAttributedString? {
        return nil
    }
    var bottomTitle: NSAttributedString?
    var topActionButtonTitle: NSAttributedString?
    var bottomActionButtonTitle: NSAttributedString? {
        return nil
    }
}
