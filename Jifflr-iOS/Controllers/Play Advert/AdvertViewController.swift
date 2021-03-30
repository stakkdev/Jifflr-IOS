//
//  AdvertViewController.swift
//  Ad-M8-iOS
//
//  Created by James Shaw on 11/10/2017.
//  Copyright © 2017 The Distance. All rights reserved.
//

import UIKit
import Appodeal
import GoogleMobileAds
import AdSupport
import Parse

class AdvertViewController: BaseViewController {
    
    var timer: Timer?
    var appodealLoaded = false
    var appodealShown = false

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    var shouldPushToFeedback = false
    var campaign: Campaign!
    var question: AdExchangeQuestion?
    var rewardedAdmob = false
    var loadError = false

    class func instantiateFromStoryboard(campaign: Campaign) -> AdvertViewController {
        let storyboard = UIStoryboard(name: "Advert", bundle: nil)
        let advertViewController = storyboard.instantiateViewController(withIdentifier: "AdvertViewController") as! AdvertViewController
        advertViewController.campaign = campaign
        return advertViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
        self.fetchData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        self.activityIndicator.stopAnimating()
    }

    func setupUI() {
        self.setupLocalization()
        self.setBackgroundImage(image: UIImage(named: "MainBackground"))

        self.navigationBar.delegate = self
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = true
        let font = UIFont(name: Constants.FontNames.GothamBold, size: 18.0)!
        self.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: font, NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationBar.tintColor = UIColor.white

        let dismissBarButton = UIBarButtonItem(image: UIImage(named: "NavigationDismiss"), style: .plain, target: self, action: #selector(self.dismissButtonPressed(sender:)))
        self.navigationBar.topItem?.rightBarButtonItem = dismissBarButton

        self.navigationController?.setNavigationBarHidden(true, animated: false)

        self.activityIndicator.startAnimating()
    }

    func setupLocalization() { }

    func fetchData() {
        AdvertManager.shared.fetchSwipeQuestion { (question) in
            guard let question = question else {
                self.handleError()
                return
            }

            self.question = question
            self.setupAdmob()
        }
    }

    func presentAppodeal() {
        guard let navVC = self.navigationController else {
            self.handleError()
            return
        }
        
        Appodeal.setRewardedVideoDelegate(self)
        Appodeal.showAd(.rewardedVideo, rootViewController: navVC)
        
        self.appodealLoaded = false
        self.timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false, block: { (timer) in
            if !self.appodealLoaded && !self.loadError {
                self.presentAppodeal()
            }
        })
    }

    func setupAdmob() {
        GADRewardBasedVideoAd.sharedInstance().delegate = self
        GADRewardBasedVideoAd.sharedInstance().load(GADRequest(), withAdUnitID: Constants.currentEnvironment.admobAdUnitId)
    }

    func presentAdmob() {
        if GADRewardBasedVideoAd.sharedInstance().isReady == true && !self.loadError {
            
            // This additional ViewController is required because of the Google Admob SDK bug.
            // See https://github.com/firebase/firebase-ios-sdk/issues/2118 Open as of Jan 2019
            let vc = LoadingViewController.instantiateFromStoryboard()
            vc.modalPresentationStyle = .fullScreen
            self.modalPresentationStyle = .fullScreen
            self.present(vc, animated: false) {
                GADRewardBasedVideoAd.sharedInstance().present(fromRootViewController: vc)
            }
        } else {
            self.handleError()
        }
    }
    
    func saveAnswers() {
        guard let user = Session.shared.currentUser else { return }
        guard let location = Session.shared.currentLocation else { return }
        
        var answers: [AdExchangeAnswer] = []
        let userSeenAdExchangeToSave = AdvertManager.shared.userSeenAdExchangeToSave
        for ad in userSeenAdExchangeToSave {
            let answer = AdExchangeAnswer()
            answer.questionNumber = ad.questionNumber
            answer.response1 = ad.response1
            answer.response2 = ad.response2
            answer.response3 = ad.response3
            answer.question = ad.question
            answers.append(answer)
        }
        
        let group = DispatchGroup()
        for answer in answers {
            group.enter()
            answer.saveEventually({ (success, error) in
                print("AdExchangeAnswer Saved: ", success)
                group.leave()
            })
        }

        group.notify(queue: .main) {
            let userSeenAdExchange = UserSeenAdExchange()
            userSeenAdExchange.user = user
            userSeenAdExchange.location = location
            if let currentCoordinate = Session.shared.currentCoordinate {
                userSeenAdExchange.geoPoint = PFGeoPoint(latitude: currentCoordinate.latitude, longitude: currentCoordinate.longitude)
            }
            let relation = userSeenAdExchange.relation(forKey: "answers")
            for answer in answers {
                relation.add(answer)
            }
            
            userSeenAdExchange.saveEventually { (success, error) in
                print("UserSeenAdExchange Saved: ", success)
            }
            
            AdvertManager.shared.userSeenAdExchangeToSave = []
        }
    }

    func presentNextAd() {
        if self.presentedViewController is LoadingViewController {
            self.presentedViewController?.dismiss(animated: false, completion: nil)
        }
        
        self.saveAnswers()
        
        let group = DispatchGroup()
        
        if self.campaign.advert.isCMS {
            group.enter()
            AdvertManager.shared.unpin(campaign: self.campaign) {
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            AdvertManager.shared.fetchNextLocal(completion: { (object) in
                guard let object = object else {
                    let title = ErrorMessage.noInternetConnection.failureTitle
                    let message = ErrorMessage.noInternetConnection.failureDescription
                    self.displayMessage(title: title, message: message, dismissText: nil, dismissAction: { (action) in
                        self.dismiss(animated: false, completion: nil)
                    })
                    return
                }
                
                if let campaign = object as? Campaign {
                    let advertViewController = CMSAdvertViewController.instantiateFromStoryboard(campaign: campaign, mode: AdViewMode.normal)
                    self.navigationController?.pushViewController(advertViewController, animated: true)
                } else if let advert = object as? Advert, let question = self.question {
                    if #available(iOS 14, *) {
                        guard AdTrackingManager.shared.adTrackingEnabled() else {
                            self.rootAdTrackingViewController()
                            return
                        }
                    } else {
                        guard ASIdentifierManager.shared().isAdvertisingTrackingEnabled else {
                            let error = ErrorMessage.advertisingTurnedOff
                            self.displayMessage(title: error.failureTitle, message: error.failureDescription, dismissText: nil) { (action) in
                                self.rootDashboardViewController()
                            }
                            return
                        }
                    }
                    
                    let campaign = Campaign()
                    campaign.advert = advert
                    let controller = SwipeFeedbackViewController.instantiateFromStoryboard(campaign: campaign, question: question)
                    self.navigationController?.pushViewController(controller, animated: true)
                }
            })
        }
    }

    @objc func dismissButtonPressed(sender: UIBarButtonItem) {
        self.dismiss(animated: false) {
            self.rootDashboardViewController(animated: false)
        }
        self.timer?.invalidate()
    }
    
    func handleError() {
        self.loadError = true
        let error = ErrorMessage.admobFetchFailed
        self.displayMessage(title: error.failureTitle, message: error.failureDescription, dismissText: nil, dismissAction: { (alert) in
            self.timer?.invalidate()
            self.dismiss(animated: false) {
                self.rootDashboardViewController(animated: false)
            }
        })
    }
}

extension AdvertViewController: AppodealRewardedVideoDelegate {
    func rewardedVideoWillDismiss() {
        self.timer?.invalidate()
        
        if self.appodealShown {
            self.presentNextAd()
        } else {
            self.activityIndicator.startAnimating()
            self.presentAppodeal()
        }
    }
    
    func rewardedVideoDidFinish(_ rewardAmount: Float, name rewardName: String?) {
        if let _ = self.navigationController?.visibleViewController as? AdvertViewController {

        } else {
            self.dismiss(animated: false, completion: {
                self.rewardedVideoWillDismiss()
            })
        }
    }
    
    func rewardedVideoDidFailToLoadAd() {
        self.timer?.invalidate()
        self.handleError()
    }
    
    func rewardedVideoDidFailToPresent() {
        self.timer?.invalidate()
        self.handleError()
    }
    
    func rewardedVideoDidPresent() {
        self.appodealLoaded = true
        self.appodealShown = false
        self.timer?.invalidate()
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false, block: { (timer) in
            self.appodealShown = true
        })
    }
}

extension AdvertViewController: GADRewardBasedVideoAdDelegate {
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd, didRewardUserWith reward: GADAdReward) {
        self.rewardedAdmob = true
        print("User Rewarded")
    }

    func rewardBasedVideoAdDidClose(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("rewardBasedVideoAdDidClose")
        if self.rewardedAdmob {
            print("Presenting Feedback")
            self.presentNextAd()
        } else {
            print("Dismissing Loading View")
            self.dismiss(animated: false) {
                print("rootDashboardViewController")
                self.rootDashboardViewController(animated: false)
            }
        }
    }

    func rewardBasedVideoAdDidReceive(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        self.presentAdmob()
    }

    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd, didFailToLoadWithError error: Error) {
        self.presentAppodeal()
    }
}


extension AdvertViewController: UINavigationBarDelegate {
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}
