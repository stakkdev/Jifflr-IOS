//
//  URLFeedbackViewController.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 09/04/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit

class URLFeedbackViewController: FeedbackViewController {
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var websiteButton: JifflrURLButton!
    @IBOutlet weak var facebookButton: JifflrURLButton!
    @IBOutlet weak var twitterButton: JifflrURLButton!
    @IBOutlet weak var onlineStoreButton: JifflrURLButton!
    @IBOutlet weak var appStoreButton: JifflrURLButton!
    
    var chosenAnswers:[Answer] = []
    
    class func instantiateFromStoryboard(advert: Advert, content: [(question: Question, answers: [Answer])], questionAnswers: [QuestionAnswers], isPreview: Bool) -> URLFeedbackViewController {
        let storyboard = UIStoryboard(name: "Advert", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "URLFeedbackViewController") as! URLFeedbackViewController
        controller.advert = advert
        controller.content = content
        controller.questionAnswers = questionAnswers
        controller.isPreview = isPreview
        return controller
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.validateInput()
        
        if Constants.isSmallScreen {
            self.stackView.spacing = 10.0
        }
        
        self.websiteButton.setImage(UIImage(named: "URLButtonWebsite"), for: .normal)
        self.facebookButton.setImage(UIImage(named: "URLButtonFacebook"), for: .normal)
        self.twitterButton.setImage(UIImage(named: "URLButtonTwitter"), for: .normal)
        self.onlineStoreButton.setImage(UIImage(named: "URLButtonOnlineStore"), for: .normal)
        self.appStoreButton.setImage(UIImage(named: "URLButtonAppStore"), for: .normal)
    }
    
    func validateInput() {
        guard let answers = self.content.first?.answers, answers.count == 6 else {
            self.nextButtonPressed(sender: self.nextAdButton)
            return
        }
    }
    
    override func setupLocalization() {
        super.setupLocalization()
        
        self.websiteButton.setTitle("urlLinks.website.title".localized(), for: .normal)
        self.facebookButton.setTitle("urlLinks.facebook.title".localized(), for: .normal)
        self.twitterButton.setTitle("urlLinks.twitter.title".localized(), for: .normal)
        self.onlineStoreButton.setTitle("urlLinks.onlineStore.title".localized(), for: .normal)
        self.appStoreButton.setTitle("urlLinks.appStore.title".localized(), for: .normal)
    }
    
    override func validateAnswers() -> Bool {
        self.createQuestionAnswers()
        
        return true
    }
    
    @IBAction func websiteButtonPressed(sender: UIButton) {
        self.openLink(index: 0)
    }
    
    @IBAction func facebookButtonPressed(sender: UIButton) {
        self.openLink(index: 1)
    }
    
    @IBAction func twitterButtonPressed(sender: UIButton) {
        self.openLink(index: 2)
    }
    
    @IBAction func onlineStoreButtonPressed(sender: UIButton) {
        self.openLink(index: 3)
    }
    
    @IBAction func appStoreButtonPressed(sender: UIButton) {
        self.openLink(index: 4)
    }
    
    func openLink(index: Int) {
        guard let answer = self.content.first?.answers[index] else { return }
        guard let url = URL(string: answer.text) else { return }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        
        self.addAnswer(answer: answer)
    }
    
    func addAnswer(answer: Answer) {
        if !self.chosenAnswers.contains(answer) {
            self.chosenAnswers.append(answer)
        }
    }
    
    func createQuestionAnswers() {
        guard let question = self.content.first?.question else { return }
        
        let questionAnswer = FeedbackManager.shared.createQuestionAnswers(question: question, answers: self.chosenAnswers)
        self.questionAnswers.append(questionAnswer)
    }
}
