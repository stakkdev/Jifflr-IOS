//
//  AddQuestionsViewController+Drawing.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 04/04/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import Foundation

extension AddQuestionsViewController {
    func drawInputUI(questionType: QuestionType) {
        switch questionType.type {
        case AdvertQuestionType.Binary, AdvertQuestionType.Rating, AdvertQuestionType.DayOfWeek, AdvertQuestionType.Month:
            self.updateScrollViewHeight()
            self.hideInputUI()
        case AdvertQuestionType.NumberPicker, AdvertQuestionType.TimePicker, AdvertQuestionType.DatePicker:
            self.drawMinMaxUI(questionType: questionType)
        case AdvertQuestionType.MultipleChoice:
            self.drawMultipleChoiceUI()
        case AdvertQuestionType.URLLinks:
            self.drawUrlsUI()
        default:
            return
        }
    }
    
    func drawUrlsUI() {
        self.answersContainerView.isHidden = true
        self.urlsContainerView.isHidden = false
        
        self.scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 850.0)
        self.nextButtonBottom.isActive = false
        self.scrollView.isScrollEnabled = true
        
        self.nextButtonTopAnswers.isActive = false
        self.nextButtonTopUrls.isActive = true
        self.view.layoutIfNeeded()
    }
    
    func drawMinMaxUI(questionType: QuestionType) {
        self.showInputUI()
        self.updateScrollViewHeight()
        
        self.minTextField.text = ""
        self.maxTextField.text = ""
        self.answer3TextField.isHidden = true
        self.answer4TextField.isHidden = true
        self.answer5TextField.isHidden = true
        self.answersRequiredLabel.isHidden = true
        self.answersRequiredTextField.isHidden = true
        self.urlsContainerView.isHidden = true
        self.answersContainerView.isHidden = false
        
        switch questionType.type {
        case AdvertQuestionType.NumberPicker:
            self.minTextField.placeholder = "addQuestions.minNumber.placeholder".localized()
            self.maxTextField.placeholder = "addQuestions.maxNumber.placeholder".localized()
            self.minTextField.keyboardType = .numberPad
            self.minTextField.inputView = nil
            self.minTextField.inputAccessoryView = nil
            self.maxTextField.keyboardType = .numberPad
            self.maxTextField.inputView = nil
            self.maxTextField.inputAccessoryView = nil
        case AdvertQuestionType.TimePicker:
            self.minTextField.placeholder = "addQuestions.minTime.placeholder".localized()
            self.maxTextField.placeholder = "addQuestions.maxTime.placeholder".localized()
            self.createMinMaxInputViews(questionType: questionType)
        case AdvertQuestionType.DatePicker:
            self.minTextField.placeholder = "addQuestions.minDate.placeholder".localized()
            self.maxTextField.placeholder = "addQuestions.maxDate.placeholder".localized()
            self.createMinMaxInputViews(questionType: questionType)
        default:
            return
        }
    }
    
    func drawMultipleChoiceUI() {
        self.showInputUI()
        
        self.minTextField.text = ""
        self.maxTextField.text = ""
        self.answer3TextField.text = ""
        self.answer4TextField.text = ""
        self.answer5TextField.text = ""
        self.answer3TextField.isHidden = false
        self.answer4TextField.isHidden = false
        self.answer5TextField.isHidden = false
        self.answersRequiredLabel.isHidden = false
        self.answersRequiredTextField.isHidden = false
        self.urlsContainerView.isHidden = true
        self.answersContainerView.isHidden = false
        
        self.minTextField.placeholder = "addQuestions.multipleChoice.placeholder".localizedFormat(1)
        self.maxTextField.placeholder = "addQuestions.multipleChoice.placeholder".localizedFormat(2)
        self.answer3TextField.placeholder = "addQuestions.multipleChoice.placeholder".localizedFormat(3)
        self.answer4TextField.placeholder = "addQuestions.multipleChoice.placeholder".localizedFormat(4)
        self.answer5TextField.placeholder = "addQuestions.multipleChoice.placeholder".localizedFormat(5)
        
        self.minTextField.keyboardType = .default
        self.minTextField.inputView = nil
        self.minTextField.inputAccessoryView = nil
        self.maxTextField.keyboardType = .default
        self.maxTextField.inputView = nil
        self.maxTextField.inputAccessoryView = nil
        
        self.scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 710.0)
        self.answersContainerViewHeight.constant = 440.0
        self.nextButtonBottom.isActive = false
        self.scrollView.isScrollEnabled = true
        
        self.nextButtonTopAnswers.isActive = true
        self.nextButtonTopUrls.isActive = false
        self.view.layoutIfNeeded()
    }
    
    func hideInputUI() {
        self.answersContainerView.isUserInteractionEnabled = false
        self.answersContainerView.isHidden = true
        self.urlsContainerView.isHidden = true
    }
    
    func showInputUI() {
        self.answersContainerView.isUserInteractionEnabled = true
        self.answersContainerView.isHidden = false
    }
    
    func createMinMaxInputViews(questionType: QuestionType) {
        self.datePicker = UIDatePicker()
        self.datePicker.date = Date()
        if questionType.type == AdvertQuestionType.DatePicker {
            self.datePicker.datePickerMode = .date
        } else {
            self.datePicker.datePickerMode = .time
        }
        self.datePicker.addTarget(self, action: #selector(datePicked), for: .valueChanged)
        self.minTextField.inputView = self.datePicker
        self.maxTextField.inputView = self.datePicker
        
        let dateToolbar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: 44.0))
        dateToolbar.barStyle = UIBarStyle.default
        let dateCloseButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.dateCloseButtonPressed))
        dateToolbar.items = [dateCloseButton]
        self.minTextField.inputAccessoryView = dateToolbar
        self.maxTextField.inputAccessoryView = dateToolbar
    }
    
    @objc func datePicked(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        
        guard let type = self.answerTypeTextField.questionType?.type else { return }
        let format = type == AdvertQuestionType.DatePicker ? "dd/MM/yyyy" : "HH:mm"
        dateFormatter.dateFormat = format
        
        guard let textField = self.getActiveTextField() else { return }
        textField.text = dateFormatter.string(from: sender.date)
    }
    
    @objc func dateCloseButtonPressed() {
        self.datePicked(sender: self.datePicker)
        self.view.endEditing(true)
    }
    
    func getActiveTextField() -> UITextField? {
        for subview in self.answersContainerView.subviews {
            guard let textField = subview as? UITextField else { continue }
            if textField.isFirstResponder {
                return textField
            }
        }
        
        return nil
    }
    
    func updateScrollViewHeight() {
        self.scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - self.scrollView.frame.origin.y)
        self.scrollView.isScrollEnabled = false
        self.answersContainerViewHeight.constant = 200.0
        self.nextButtonBottom.isActive = true
        self.view.layoutIfNeeded()
    }
    
    func drawQuestionData(questionType: QuestionType) {
        switch questionType.type {
        case AdvertQuestionType.NumberPicker, AdvertQuestionType.TimePicker, AdvertQuestionType.DatePicker:
            self.drawFirstLastQuestionUI()
        case AdvertQuestionType.MultipleChoice:
            self.drawMultipleChoiceQuestionUI()
        case AdvertQuestionType.URLLinks:
            self.drawUrlsQuestionUI()
        default:
            return
        }
    }
    
    func drawFirstLastQuestionUI() {
        let answers = self.content[self.questionNumber - 1].answers
        guard answers.count == 2 else { return }
        
        let firstAnswer = answers.first!
        if let date = firstAnswer.date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let text = dateFormatter.string(from: date)
            self.minTextField.text = text
        } else {
            self.minTextField.text = firstAnswer.text
        }
        
        let lastAnswer = answers.last!
        if let date = lastAnswer.date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let text = dateFormatter.string(from: date)
            self.maxTextField.text = text
        } else {
            self.maxTextField.text = lastAnswer.text
        }
    }
    
    func drawUrlsQuestionUI() {
        let answers = self.content[self.questionNumber - 1].answers
        guard answers.count == 6 else { return }
        
        self.websiteTextField.text = answers.first!.text
        self.facebookTextField.text = answers[1].text
        self.twitterTextField.text = answers[2].text
        self.onlineStoreTextField.text = answers[3].text
        self.appStoreTextField.text = answers[4].text
        self.playStoreTextField.text = answers[5].text
    }
    
    func drawMultipleChoiceQuestionUI() {
        let question = self.content[self.questionNumber - 1].question
        if let noOfRequiredAnswers = question.noOfRequiredAnswers {
            self.answersRequiredTextField.text = "\(noOfRequiredAnswers)"
        }
        
        let answers = self.content[self.questionNumber - 1].answers
        
        for (index, answer) in answers.enumerated() {
            switch index {
            case 0:
                self.minTextField.text = answer.text
            case 1:
                self.maxTextField.text = answer.text
            case 2:
                self.answer3TextField.text = answer.text
            case 3:
                self.answer4TextField.text = answer.text
            case 4:
                self.answer5TextField.text = answer.text
            default:
                return
            }
        }
    }
}
