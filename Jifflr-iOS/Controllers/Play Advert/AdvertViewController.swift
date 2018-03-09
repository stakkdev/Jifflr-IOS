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

class AdvertViewController: BaseViewController {

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    var shouldPushToFeedback = false
    var advert: Advert!
    var questions: [Question] = []
    var answers: [Answer] = []

    class func instantiateFromStoryboard(advert: Advert) -> AdvertViewController {
        let storyboard = UIStoryboard(name: "Advert", bundle: nil)
        let advertViewController = storyboard.instantiateViewController(withIdentifier: "AdvertViewController") as! AdvertViewController
        advertViewController.advert = advert
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
        AdvertManager.shared.fetchSwipeQuestions { (questions) in
            guard questions.count > 0 else {
                self.displayError(error: ErrorMessage.admobFetchFailed)
                return
            }

            self.questions = questions
            questions.first!.fetchAnswers(completion: { (answers) in
                self.answers = answers
                self.presentAppodeal()
            })
        }
    }

    func presentAppodeal() {
        Appodeal.setNonSkippableVideoDelegate(self)
        Appodeal.showAd(.nonSkippableVideo, rootViewController: self)
    }

    func setupAdmob() {
        GADRewardBasedVideoAd.sharedInstance().delegate = self
        GADRewardBasedVideoAd.sharedInstance().load(GADRequest(), withAdUnitID: Constants.currentEnvironment.admobKey)
    }

    func presentAdmob() {
        if GADRewardBasedVideoAd.sharedInstance().isReady == true {
            GADRewardBasedVideoAd.sharedInstance().present(fromRootViewController: self)
        }
    }

    func presentFeedback() {
        guard let firstQuestion = self.questions.first, firstQuestion.type.type == AdvertQuestionType.Swipe else {
            print("Invalid Question Type")
            return
        }

        let controller = SwipeFeedbackViewController.instantiateFromStoryboard(advert: self.advert, questions: self.questions, answers: self.answers)
        self.navigationController?.pushViewController(controller, animated: true)
    }

    @objc func dismissButtonPressed(sender: UIBarButtonItem) {
        self.dismiss(animated: false, completion: nil)
    }
}

extension AdvertViewController: AppodealNonSkippableVideoDelegate {
    func nonSkippableVideoWillDismiss() {
        self.presentFeedback()
    }

    func nonSkippableVideoDidFinish() {
        self.dismiss(animated: true)
    }

    func nonSkippableVideoDidFailToLoadAd() {
        self.setupAdmob()
    }

    func nonSkippableVideoDidFailToPresent() {
        self.setupAdmob()
    }
}

extension AdvertViewController: GADRewardBasedVideoAdDelegate {
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd, didRewardUserWith reward: GADAdReward) {
        self.dismiss(animated: true)
    }

    func rewardBasedVideoAdDidClose(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        self.presentFeedback()
    }

    func rewardBasedVideoAdDidReceive(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        self.presentAdmob()
    }

    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd, didFailToLoadWithError error: Error) {
        let error = ErrorMessage.admobFetchFailed
        self.displayMessage(title: error.failureTitle, message: error.failureDescription, dismissText: nil, dismissAction: { (alert) in
            self.navigationController?.dismiss(animated: false, completion: nil)
        })
    }
}


extension AdvertViewController: UINavigationBarDelegate {
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}
