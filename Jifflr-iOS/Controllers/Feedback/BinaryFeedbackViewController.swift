//
//  BinaryFeedbackViewController.swift
//  Ad-M8-iOS
//
//  Created by James Shaw on 11/10/2017.
//  Copyright © 2017 The Distance. All rights reserved.
//

import UIKit
import Parse

class BinaryFeedbackViewController: FeedbackViewController {

    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var yesButton: UIButton!

    class func instantiateFromStoryboard(campaign: Campaign, content: [(question: Question, answers: [Answer])], questionAnswers: [QuestionAnswers], mode: Int) -> BinaryFeedbackViewController {
        let storyboard = UIStoryboard(name: "Advert", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "BinaryFeedbackViewController") as! BinaryFeedbackViewController
        controller.campaign = campaign
        controller.content = content
        controller.questionAnswers = questionAnswers
        controller.mode = mode
        
        OrientationManager.shared.lock(orientation: .portrait, andRotateTo: .portrait)
        
        return controller
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func noPressed(sender: UIButton) {
        if sender.tag == 0 {
            sender.tag = 1
            sender.setImage(UIImage(named: "FeedbackNoButtonSelected"), for: .normal)

            self.yesButton.tag = 0
            self.yesButton.setImage(UIImage(named: "FeedbackYesButton"), for: .normal)
        }
    }

    @IBAction func yesPressed(sender: UIButton) {
        if sender.tag == 0 {
            sender.tag = 1
            sender.setImage(UIImage(named: "FeedbackYesButtonSelected"), for: .normal)

            self.noButton.tag = 0
            self.noButton.setImage(UIImage(named: "FeedbackNoButton"), for: .normal)
        }
    }

    override func validateAnswers() -> Bool {
        if self.noButton.tag == 0 && self.yesButton.tag == 0 {
            return false
        }
        
        let yes = self.yesButton.tag == 1
        self.createQuestionAnswers(yes: yes)

        return true
    }
    
    func createQuestionAnswers(yes: Bool) {
        guard let question = self.content.first?.question else { return }
        guard let answers = self.content.first?.answers else { return }
        guard answers.count == 2 else { return }
        let answer = yes == true ? answers.last! : answers.first!
        let questionAnswer = FeedbackManager.shared.createQuestionAnswers(question: question, answers: [answer])
        self.questionAnswers.append(questionAnswer)
    }
}
