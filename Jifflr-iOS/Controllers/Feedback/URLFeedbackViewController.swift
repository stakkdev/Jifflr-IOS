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
    
    class func instantiateFromStoryboard(campaign: Campaign, content: [(question: Question, answers: [Answer])], questionAnswers: [QuestionAnswers], mode: Int) -> URLFeedbackViewController {
        let storyboard = UIStoryboard(name: "Advert", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "URLFeedbackViewController") as! URLFeedbackViewController
        controller.campaign = campaign
        controller.content = content
        controller.questionAnswers = questionAnswers
        controller.mode = mode
        
        OrientationManager.shared.lock(orientation: .portrait, andRotateTo: .portrait)
        
        return controller
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Constants.isSmallScreen {
            self.stackView.spacing = 10.0
        }
        
        self.websiteButton.setImage(UIImage(named: "URLButtonWebsite"), for: .normal)
        self.facebookButton.setImage(UIImage(named: "URLButtonFacebook"), for: .normal)
        self.twitterButton.setImage(UIImage(named: "URLButtonTwitter"), for: .normal)
        self.onlineStoreButton.setImage(UIImage(named: "URLButtonOnlineStore"), for: .normal)
        self.appStoreButton.setImage(UIImage(named: "URLButtonAppStore"), for: .normal)
        
        self.setupStackView()
    }
    
    override func setupLocalization() {
        super.setupLocalization()
        
        self.websiteButton.setTitle("urlLinks.website.title".localized(), for: .normal)
        self.facebookButton.setTitle("urlLinks.facebook.title".localized(), for: .normal)
        self.twitterButton.setTitle("urlLinks.twitter.title".localized(), for: .normal)
        self.onlineStoreButton.setTitle("urlLinks.onlineStore.title".localized(), for: .normal)
        self.appStoreButton.setTitle("urlLinks.appStore.title".localized(), for: .normal)
    }
    
    func setupStackView() {
        guard let content = self.content.first else { return }
        
        if !content.answers.contains(where: { $0.urlType == URLTypes.website }) {
            self.stackView.removeArrangedSubview(self.websiteButton)
            self.websiteButton.removeFromSuperview()
        }
        
        if !content.answers.contains(where: { $0.urlType == URLTypes.facebook }) {
            self.stackView.removeArrangedSubview(self.facebookButton)
            self.facebookButton.removeFromSuperview()
        }
        
        if !content.answers.contains(where: { $0.urlType == URLTypes.twitter }) {
            self.stackView.removeArrangedSubview(self.twitterButton)
            self.twitterButton.removeFromSuperview()
        }
        
        if !content.answers.contains(where: { $0.urlType == URLTypes.onlineStore }) {
            self.stackView.removeArrangedSubview(self.onlineStoreButton)
            self.onlineStoreButton.removeFromSuperview()
        }
        
        if !content.answers.contains(where: { $0.urlType == URLTypes.iOS }) {
            self.stackView.removeArrangedSubview(self.appStoreButton)
            self.appStoreButton.removeFromSuperview()
        }
    }
    
    override func validateAnswers() -> Bool {
        self.createQuestionAnswers()
        
        return true
    }
    
    @IBAction func websiteButtonPressed(sender: UIButton) {
        self.openLink(urlType: URLTypes.website)
    }
    
    @IBAction func facebookButtonPressed(sender: UIButton) {
        self.openLink(urlType: URLTypes.facebook)
    }
    
    @IBAction func twitterButtonPressed(sender: UIButton) {
        self.openLink(urlType: URLTypes.twitter)
    }
    
    @IBAction func onlineStoreButtonPressed(sender: UIButton) {
        self.openLink(urlType: URLTypes.onlineStore)
    }
    
    @IBAction func appStoreButtonPressed(sender: UIButton) {
        self.openLink(urlType: URLTypes.iOS)
    }
    
    func openLink(urlType: String) {
        guard let answers = self.content.first?.answers.filter({ $0.urlType == urlType }) else { return }
        guard let answer = answers.first else { return }
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
