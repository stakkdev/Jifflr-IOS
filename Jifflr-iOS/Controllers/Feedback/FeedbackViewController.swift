//
//  FeedbackViewController.swift
//  Ad-M8-iOS
//
//  Created by James Shaw on 11/10/2017.
//  Copyright © 2017 The Distance. All rights reserved.
//

import UIKit
import Parse

class FeedbackViewController: BaseViewController {

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var nextAdButton: JifflrButton!
    @IBOutlet weak var createAdCampaignButton: UIButton!

    var advert: Advert!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
    }

    func setupUI() {
        self.setupLocalization()

        self.setBackgroundImage(image: UIImage(named: "MainBackground"))
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.setHidesBackButton(true, animated: false)

        self.nextAdButton.setBackgroundColor(color: UIColor.mainPink)

        let skipBarButton = UIBarButtonItem(title: "onboarding.skipButton".localized(), style: .plain, target: self, action: #selector(self.skipButtonPressed(sender:)))
        let skipFont = UIFont(name: Constants.FontNames.GothamBook, size: 16.0)!
        skipBarButton.setTitleTextAttributes([NSAttributedStringKey.font: skipFont], for: .normal)
        self.navigationItem.rightBarButtonItem = skipBarButton
    }

    func setupLocalization() {
        self.nextAdButton.setTitle("feedback.nextAdButton.title".localized(), for: .normal)

        let createAdButtonFont = UIFont(name: Constants.FontNames.GothamMedium, size: 14.0)!
        let attributes = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: createAdButtonFont, NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue] as [NSAttributedStringKey : Any]
        let attributedString = NSAttributedString(string: "feedback.createAdButton.title".localized(), attributes: attributes)
        self.createAdCampaignButton.setAttributedTitle(attributedString, for: .normal)
    }

    @objc func skipButtonPressed(sender: UIBarButtonItem) {
        self.pushToNextAd()
    }

    @IBAction func nextButtonPressed(sender: JifflrButton) {
        guard self.validateAnswers() else {
            self.displayError(error: ErrorMessage.invalidFeedback)
            return
        }

        // TODO: Save Feedback

        self.pushToNextAd()
    }

    func validateAnswers() -> Bool {
        return false
    }

    @IBAction func createAdCampaignButtonPressed(sender: UIButton) {

    }

    func pushToNextAd() {
        self.navigationController?.viewControllers.removeFirst()
        let advertViewController = AdvertViewController.instantiateFromStoryboard(advert: self.advert)
        self.navigationController?.pushViewController(advertViewController, animated: true)
    }
}
