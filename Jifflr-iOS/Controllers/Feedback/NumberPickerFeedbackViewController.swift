//
//  NumberPickerFeedbackViewController.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 09/03/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit

class NumberPickerFeedbackViewController: FeedbackViewController {

    @IBOutlet weak var pickerView: UIPickerView!

    var numbers:[Int] = []

    class func instantiateFromStoryboard(advert: Advert, content: [(question: Question, answers: [Answer])], questionAnswers: [QuestionAnswers]) -> NumberPickerFeedbackViewController {
        let storyboard = UIStoryboard(name: "Advert", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "NumberPickerFeedbackViewController") as! NumberPickerFeedbackViewController
        controller.advert = advert
        controller.content = content
        controller.questionAnswers = questionAnswers
        return controller
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupData()

        self.pickerView.delegate = self
        self.pickerView.dataSource = self
    }
    
    func setupData() {
        guard let answers = self.content.first?.answers else { return }
        guard answers.count == 2 else { return }
        guard let firstAnswer = answers.first?.text else { return }
        guard let lastAnswer = answers.last?.text else { return }
        guard let firstNumber = Int(firstAnswer) else { return }
        guard let lastNumber = Int(lastAnswer) else { return }
        
        for number in firstNumber...lastNumber {
            self.numbers.append(number)
        }
    }

    override func validateAnswers() -> Bool {
        let selectedIndex = self.pickerView.selectedRow(inComponent: 0)
        let chosenNumber = self.numbers[selectedIndex]
        self.createQuestionAnswers(number: chosenNumber)
        
        return true
    }
    
    func createQuestionAnswers(number: Int) {
        guard let question = self.content.first?.question else { return }
        
        let answer = FeedbackManager.shared.createAndSaveAnswer(number: number, date: nil)
        
        let questionAnswer = FeedbackManager.shared.createQuestionAnswers(question: question, answers: [answer])
        self.questionAnswers.append(questionAnswer)
    }
}

extension NumberPickerFeedbackViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.numbers.count
    }

    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let answer = numbers[row]
        let font = UIFont(name: Constants.FontNames.GothamBook, size: 20.0)!
        let attributes = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: font]
        let attributedString = NSAttributedString(string: "\(answer)", attributes: attributes)
        return attributedString
    }
}
