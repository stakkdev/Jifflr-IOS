//
//  DateTimeFeedbackViewController.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 09/03/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit

class DateTimeFeedbackViewController: FeedbackViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    
    var isTime = false

    class func instantiateFromStoryboard(advert: Advert, content: [(question: Question, answers: [Answer])], questionAnswers: [QuestionAnswers], isTime: Bool) -> DateTimeFeedbackViewController {
        let storyboard = UIStoryboard(name: "Advert", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "DateTimeFeedbackViewController") as! DateTimeFeedbackViewController
        controller.advert = advert
        controller.content = content
        controller.questionAnswers = questionAnswers
        controller.isTime = isTime
        return controller
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupDatePicker()
    }
    
    func setupDatePicker() {
        self.datePicker.setValue(UIColor.white, forKey: "textColor")
        self.datePicker.setValue(false, forKey: "highlightsToday")
        
        if self.isTime {
            self.datePicker.datePickerMode = .time
        } else {
            self.datePicker.datePickerMode = .date
        }
        
        guard let answers = self.content.first?.answers else { return }
        guard answers.count == 2 else { return }
        guard let firstDate = answers.first?.date else { return }
        guard let lastDate = answers.last?.date else { return }
        
        self.datePicker.minimumDate = firstDate
        self.datePicker.maximumDate = lastDate
        self.datePicker.date = firstDate
    }

    override func validateAnswers() -> Bool {
        self.createQuestionAnswers()
        
        return true
    }
    
    func createQuestionAnswers() {
        guard let question = self.content.first?.question else { return }
        
        let answer = FeedbackManager.shared.createAndSaveAnswer(number: nil, date: self.datePicker.date)
        
        let questionAnswer = FeedbackManager.shared.createQuestionAnswers(question: question, answers: [answer])
        self.questionAnswers.append(questionAnswer)
    }
}
