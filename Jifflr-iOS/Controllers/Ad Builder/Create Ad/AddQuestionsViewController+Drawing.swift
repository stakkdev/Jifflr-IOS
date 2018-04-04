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
            self.hideInputUI()
        case AdvertQuestionType.NumberPicker, AdvertQuestionType.TimePicker, AdvertQuestionType.DatePicker:
            self.drawMinMaxUI(questionType: questionType)
        case AdvertQuestionType.MultipleChoice:
            self.drawMultipleChoiceUI()
        default:
            return
        }
    }
    
    func drawMinMaxUI(questionType: QuestionType) {
        self.showInputUI()
        
        self.minTextField.isHidden = false
        self.maxTextField.isHidden = false
        self.minTextField.text = ""
        self.maxTextField.text = ""
        
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
        
        self.minTextField.isHidden = true
        self.maxTextField.isHidden = true
        self.minTextField.text = ""
        self.maxTextField.text = ""
    }
    
    func hideInputUI() {
        self.answersContainerView.isUserInteractionEnabled = false
        self.answersContainerView.isHidden = true
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
}
