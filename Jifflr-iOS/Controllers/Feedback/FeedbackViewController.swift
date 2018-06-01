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

    var campaign: Campaign!
    var content:[(question: Question, answers: [Answer])] = []
    var questionAnswers:[QuestionAnswers] = []
    
    var mode = 1

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        switch self.mode {
        case AdViewMode.normal:
            self.timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false, block: { (timer) in
                self.nextAdButton.isEnabled = true
                
                UIView.animate(withDuration: 0.2, animations: {
                    self.nextAdButton.alpha = 1.0
                })
            })
        case AdViewMode.preview:
            self.nextAdButton.isEnabled = true
            self.nextAdButton.alpha = 0.5
        case AdViewMode.moderator:
            self.nextAdButton.isEnabled = true
            self.nextAdButton.alpha = 1.0
        default:
            return
        }
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
        
        self.createAdCampaignButton.isEnabled = self.mode == AdViewMode.normal

        let skipBarButton = UIBarButtonItem(title: "onboarding.skipButton".localized(), style: .plain, target: self, action: #selector(self.skipButtonPressed(sender:)))
        let skipFont = UIFont(name: Constants.FontNames.GothamBook, size: 16.0)!
        skipBarButton.setTitleTextAttributes([NSAttributedStringKey.font: skipFont], for: .normal)
        skipBarButton.isEnabled = self.mode == AdViewMode.normal
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
        if self.mode == AdViewMode.normal {
            guard self.validateAnswers() else {
                let value = self.content.first?.question.noOfRequiredAnswers ?? 1
                self.displayError(error: ErrorMessage.invalidFeedback(value))
                return
            }
            
            if self.content.count > 1 {
                self.pushToNextQuestion()
            } else {
                FeedbackManager.shared.saveFeedback(campaign: self.campaign, questionAnswers: self.questionAnswers, completion: {
                    self.pushToNextAd()
                })
            }
        } else {
            if self.content.count > 1 {
                self.pushToNextQuestion()
            } else {
                let vc = ModerationFeedbackViewController.instantiateFromStoryboard(campaign: self.campaign)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }

    func validateAnswers() -> Bool {
        return false
    }

    @IBAction func createAdCampaignButtonPressed(sender: UIButton) {
        self.dismiss(animated: true) {
            guard let window = UIApplication.shared.keyWindow, let rootViewController = window.rootViewController else { return }
            guard let navController = rootViewController as? UINavigationController else { return }
            guard let dashboardViewController = navController.visibleViewController as? DashboardViewController else { return }
            
            dashboardViewController.adBuilderPressed(dashboardViewController.adBuilderButton)
        }
    }

    func pushToNextAd() {
        let group = DispatchGroup()
        
        self.nextAdButton.animate()
        
        if self.campaign.advert.isCMS {
            group.enter()
            AdvertManager.shared.unpin(campaign: self.campaign) {
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            AdvertManager.shared.fetchNextLocal(completion: { (object) in
                self.nextAdButton.stopAnimating()
                
                guard let object = object else {
                    self.dismiss(animated: false, completion: nil)
                    return
                }
                
                if let campaign = object as? Campaign {
                    let advertViewController = CMSAdvertViewController.instantiateFromStoryboard(campaign: campaign, mode: AdViewMode.normal)
                    self.navigationController?.pushViewController(advertViewController, animated: true)
                } else if let advert = object as? Advert {
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
            controller = BinaryFeedbackViewController.instantiateFromStoryboard(campaign: self.campaign, content: self.content, questionAnswers: self.questionAnswers, mode: self.mode)
        case AdvertQuestionType.DatePicker:
            controller = DateTimeFeedbackViewController.instantiateFromStoryboard(campaign: self.campaign, content: self.content, questionAnswers: self.questionAnswers, isTime: false, mode: self.mode)
        case AdvertQuestionType.MultipleChoice, AdvertQuestionType.Month, AdvertQuestionType.DayOfWeek:
            controller = MultiSelectFeedbackViewController.instantiateFromStoryboard(campaign: self.campaign, content: self.content, questionAnswers: self.questionAnswers, mode: self.mode)
        case AdvertQuestionType.NumberPicker:
            controller = NumberPickerFeedbackViewController.instantiateFromStoryboard(campaign: self.campaign, content: self.content, questionAnswers: self.questionAnswers, mode: self.mode)
        case AdvertQuestionType.Rating:
            controller = ScaleFeedbackViewController.instantiateFromStoryboard(campaign: self.campaign, content: self.content, questionAnswers: self.questionAnswers, mode: self.mode)
        case AdvertQuestionType.TimePicker:
            controller = DateTimeFeedbackViewController.instantiateFromStoryboard(campaign: self.campaign, content: self.content, questionAnswers: self.questionAnswers, isTime: true, mode: self.mode)
        case AdvertQuestionType.URLLinks:
            controller = URLFeedbackViewController.instantiateFromStoryboard(campaign: self.campaign, content: self.content, questionAnswers: [], mode: self.mode)
        default:
            controller = BinaryFeedbackViewController.instantiateFromStoryboard(campaign: self.campaign, content: self.content, questionAnswers: self.questionAnswers, mode: self.mode)
        }
        
        self.navigationController?.pushViewController(controller, animated: true)
    }

    @objc func skipButtonPressed(sender: UIBarButtonItem) {
        self.pushToNextAd()
    }

    @objc func dismissButtonPressed(sender: UIBarButtonItem) {
        self.dismiss(animated: self.mode == AdViewMode.preview, completion: nil)
    }
}
