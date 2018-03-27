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

    var timer: Timer?

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var nextAdButton: JifflrButton!
    @IBOutlet weak var createAdCampaignButton: UIButton!

    var advert: Advert!
    var content:[(question: Question, answers: [Answer])] = []
    var questionAnswers:[QuestionAnswers] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false, block: { (timer) in
            self.nextAdButton.isEnabled = true

            UIView.animate(withDuration: 0.2, animations: {
                self.nextAdButton.alpha = 1.0
            })
        })
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        self.timer?.invalidate()
        self.timer = nil
    }

    func setupUI() {
        self.setupLocalization()
        self.setupQuestionText()

        self.setBackgroundImage(image: UIImage(named: "MainBackground"))
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.setHidesBackButton(true, animated: false)

        self.nextAdButton.setBackgroundColor(color: UIColor.mainPink)
        self.nextAdButton.isEnabled = false
        self.nextAdButton.alpha = 0.5

        let skipBarButton = UIBarButtonItem(title: "onboarding.skipButton".localized(), style: .plain, target: self, action: #selector(self.skipButtonPressed(sender:)))
        let skipFont = UIFont(name: Constants.FontNames.GothamBook, size: 16.0)!
        skipBarButton.setTitleTextAttributes([NSAttributedStringKey.font: skipFont], for: .normal)
        self.navigationItem.rightBarButtonItem = skipBarButton

        let dismissBarButton = UIBarButtonItem(image: UIImage(named: "NavigationDismiss"), style: .plain, target: self, action: #selector(self.dismissButtonPressed(sender:)))
        self.navigationItem.leftBarButtonItem = dismissBarButton
    }
    
    func setupQuestionText() {
        guard let question = self.content.first?.question else { return }
        self.questionLabel.text = question.text
    }

    func setupLocalization() {
        self.nextAdButton.setTitle("feedback.nextAdButton.title".localized(), for: .normal)

        let createAdButtonFont = UIFont(name: Constants.FontNames.GothamMedium, size: 14.0)!
        let attributes = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: createAdButtonFont, NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue] as [NSAttributedStringKey : Any]
        let attributedString = NSAttributedString(string: "feedback.createAdButton.title".localized(), attributes: attributes)
        self.createAdCampaignButton.setAttributedTitle(attributedString, for: .normal)
    }

    @IBAction func nextButtonPressed(sender: JifflrButton) {
        guard self.validateAnswers() else {
            self.displayError(error: ErrorMessage.invalidFeedback)
            return
        }
        
        if self.content.count > 1 {
            self.pushToNextQuestion()
        } else {
            FeedbackManager.shared.saveFeedback(advert: self.advert, questionAnswers: self.questionAnswers, completion: {
                self.pushToNextAd()
            })
        }
    }

    func validateAnswers() -> Bool {
        return false
    }

    @IBAction func createAdCampaignButtonPressed(sender: UIButton) {

    }

    func pushToNextAd() {
        let group = DispatchGroup()
        
        if advert.isCMS {
            group.enter()
            self.advert.unpinInBackground(withName: AdvertManager.shared.pinName) { (success, error) in
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            AdvertManager.shared.fetchNextLocal(completion: { (advert) in
                guard let advert = advert else {
                    self.dismiss(animated: false, completion: nil)
                    return
                }
                
                if advert.isCMS {
                    let advertViewController = CMSAdvertViewController.instantiateFromStoryboard(advert: advert, isPreview: false)
                    self.navigationController?.pushViewController(advertViewController, animated: true)
                } else {
                    let advertViewController = AdvertViewController.instantiateFromStoryboard(advert: advert)
                    self.navigationController?.pushViewController(advertViewController, animated: true)
                }
            })
        }
    }
    
    func pushToNextQuestion() {
        self.content.removeFirst()
        guard let question = self.content.first?.question else { return }
        
        var controller: UIViewController!
        
        switch question.type.type {
        case AdvertQuestionType.Binary:
            controller = BinaryFeedbackViewController.instantiateFromStoryboard(advert: self.advert, content: self.content, questionAnswers: self.questionAnswers)
        case AdvertQuestionType.DatePicker:
            controller = DateTimeFeedbackViewController.instantiateFromStoryboard(advert: self.advert, content: self.content, questionAnswers: self.questionAnswers, isTime: false)
        case AdvertQuestionType.MultiSelect:
            controller = MultiSelectFeedbackViewController.instantiateFromStoryboard(advert: self.advert, content: self.content, questionAnswers: self.questionAnswers)
        case AdvertQuestionType.NumberPicker:
            controller = NumberPickerFeedbackViewController.instantiateFromStoryboard(advert: self.advert, content: self.content, questionAnswers: self.questionAnswers)
        case AdvertQuestionType.Scale:
            controller = ScaleFeedbackViewController.instantiateFromStoryboard(advert: self.advert, content: self.content, questionAnswers: self.questionAnswers)
        case AdvertQuestionType.TimePicker:
            controller = DateTimeFeedbackViewController.instantiateFromStoryboard(advert: self.advert, content: self.content, questionAnswers: self.questionAnswers, isTime: true)
        default:
            controller = BinaryFeedbackViewController.instantiateFromStoryboard(advert: self.advert, content: self.content, questionAnswers: self.questionAnswers)
        }
        
        self.navigationController?.pushViewController(controller, animated: true)
    }

    @objc func skipButtonPressed(sender: UIBarButtonItem) {
        self.pushToNextAd()
    }

    @objc func dismissButtonPressed(sender: UIBarButtonItem) {
        self.dismiss(animated: false, completion: nil)
    }
}
