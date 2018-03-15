//
//  RatingFeedbackViewController.swift
//  Ad-M8-iOS
//
//  Created by James Shaw on 11/10/2017.
//  Copyright © 2017 The Distance. All rights reserved.
//

import UIKit

class ScaleFeedbackViewController: FeedbackViewController {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var scale1Button: ScaleButton!
    @IBOutlet weak var scale2Button: ScaleButton!
    @IBOutlet weak var scale3Button: ScaleButton!
    @IBOutlet weak var scale4Button: ScaleButton!
    @IBOutlet weak var scale5Button: ScaleButton!

    class func instantiateFromStoryboard(advert: Advert, content: [(question: Question, answers: [Answer])], questionAnswers: [QuestionAnswers]) -> ScaleFeedbackViewController {
        let storyboard = UIStoryboard(name: "Advert", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ScaleFeedbackViewController") as! ScaleFeedbackViewController
        controller.advert = advert
        controller.content = content
        controller.questionAnswers = questionAnswers
        return controller
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func validateAnswers() -> Bool {

        guard self.scale1Button.tag == 1 ||
            self.scale2Button.tag == 1 ||
            self.scale3Button.tag == 1 ||
            self.scale4Button.tag == 1 ||
            self.scale5Button.tag == 1 else {
                return false
        }
        
        if self.scale1Button.tag == 1 {
            self.createQuestionAnswers(index: 0)
            return true
        }
        
        if self.scale2Button.tag == 1 {
            self.createQuestionAnswers(index: 1)
            return true
        }
        
        if self.scale3Button.tag == 1 {
            self.createQuestionAnswers(index: 2)
            return true
        }
        
        if self.scale4Button.tag == 1 {
            self.createQuestionAnswers(index: 3)
            return true
        }
        
        if self.scale5Button.tag == 1 {
            self.createQuestionAnswers(index: 4)
            return true
        }

        return true
    }
    
    func createQuestionAnswers(index: Int) {
        guard let question = self.content.first?.question else { return }
        guard let answers = self.content.first?.answers else { return }
        guard answers.count == 5 else { return }
        
        let filteredAnswers = answers.filter { ($0.index == index) }
        guard let answer = filteredAnswers.first else { return }
        
        let questionAnswer = FeedbackManager.shared.createQuestionAnswers(question: question, answers: [answer])
        self.questionAnswers.append(questionAnswer)
    }

    @IBAction func feedback1Selected(sender: UIButton) {
        guard self.scale1Button.tag == 0 else { return }
        self.scale1Button.setButton(on: true, scale: 1)
        self.scale2Button.setButton(on: false, scale: 2)
        self.scale3Button.setButton(on: false, scale: 3)
        self.scale4Button.setButton(on: false, scale: 4)
        self.scale5Button.setButton(on: false, scale: 5)
    }

    @IBAction func feedback2Selected(sender: UIButton) {
        guard self.scale2Button.tag == 0 else { return }
        self.scale1Button.setButton(on: false, scale: 1)
        self.scale2Button.setButton(on: true, scale: 2)
        self.scale3Button.setButton(on: false, scale: 3)
        self.scale4Button.setButton(on: false, scale: 4)
        self.scale5Button.setButton(on: false, scale: 5)
    }

    @IBAction func feedback3Selected(sender: UIButton) {
        guard self.scale3Button.tag == 0 else { return }
        self.scale1Button.setButton(on: false, scale: 1)
        self.scale2Button.setButton(on: false, scale: 2)
        self.scale3Button.setButton(on: true, scale: 3)
        self.scale4Button.setButton(on: false, scale: 4)
        self.scale5Button.setButton(on: false, scale: 5)
    }

    @IBAction func feedback4Selected(sender: UIButton) {
        guard self.scale4Button.tag == 0 else { return }
        self.scale1Button.setButton(on: false, scale: 1)
        self.scale2Button.setButton(on: false, scale: 2)
        self.scale3Button.setButton(on: false, scale: 3)
        self.scale4Button.setButton(on: true, scale: 4)
        self.scale5Button.setButton(on: false, scale: 5)
    }

    @IBAction func feedback5Selected(sender: UIButton) {
        guard self.scale5Button.tag == 0 else { return }
        self.scale1Button.setButton(on: false, scale: 1)
        self.scale2Button.setButton(on: false, scale: 2)
        self.scale3Button.setButton(on: false, scale: 3)
        self.scale4Button.setButton(on: false, scale: 4)
        self.scale5Button.setButton(on: true, scale: 5)
    }
}
