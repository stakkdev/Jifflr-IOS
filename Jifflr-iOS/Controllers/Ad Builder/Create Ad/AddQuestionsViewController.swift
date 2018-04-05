//
//  AddQuestionsViewController.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 03/04/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit

class AddQuestionsViewController: BaseViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var previewButton: JifflrButton!
    @IBOutlet weak var nextButton: JifflrButton!
    @IBOutlet var nextButtonBottom: NSLayoutConstraint!
    @IBOutlet weak var questionTextView: JifflrTextView!
    @IBOutlet weak var answerTypeLabel: UILabel!
    @IBOutlet weak var answerTypeTextField: JifflrTextFieldDropdown!
    @IBOutlet weak var answersLabel: UILabel!
    @IBOutlet weak var answersContainerView: UIView!
    @IBOutlet weak var answersContainerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var minTextField: JifflrTextField!
    @IBOutlet weak var maxTextField: JifflrTextField!
    @IBOutlet weak var answer3TextField: JifflrTextField!
    @IBOutlet weak var answer4TextField: JifflrTextField!
    @IBOutlet weak var answer5TextField: JifflrTextField!
    @IBOutlet weak var answersRequiredLabel: UILabel!
    @IBOutlet weak var answersRequiredTextField: JifflrTextFieldDropdown!
    
    var pickerView: UIPickerView!
    var datePicker: UIDatePicker!
    
    var advert: Advert!
    var questionTypes: [QuestionType] = []
    var questionNumber = 0

    class func instantiateFromStoryboard(advert: Advert, questionNumber: Int) -> AddQuestionsViewController {
        let storyboard = UIStoryboard(name: "CreateAd", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AddQuestionsViewController") as! AddQuestionsViewController
        vc.advert = advert
        vc.questionNumber = questionNumber
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        self.setupData()
    }
    
    func setupUI() {
        self.setupLocalization()
        self.setBackgroundImage(image: UIImage(named: "MainBackground"))
        
        self.nextButton.setBackgroundColor(color: UIColor.mainPink)
        self.previewButton.setBackgroundColor(color: UIColor.mainBlueTransparent80)
        
        self.questionTextView.textContainer.maximumNumberOfLines = 3
        self.questionTextView.textContainer.lineBreakMode = .byTruncatingTail
        
        let questionSwitch = UISwitch()
        questionSwitch.addTarget(self, action: #selector(self.questionSwitchToggled(sender:)), for: .valueChanged)
        questionSwitch.onTintColor = UIColor.mainOrange
        questionSwitch.backgroundColor = UIColor.offSwitchGrey
        questionSwitch.layer.cornerRadius = 16.0
        let switchBarButton = UIBarButtonItem(customView: questionSwitch)
        self.navigationItem.rightBarButtonItem = switchBarButton
        
        if self.questionNumber == 1 {
            questionSwitch.isOn = true
        } else {
            questionSwitch.isOn = false
        }
        self.questionSwitchToggled(sender: questionSwitch)
        
        self.createInputViews()
    }
    
    func setupLocalization() {
        self.title = "addQuestions.navigation.title".localizedFormat(self.questionNumber)
        self.nextButton.setTitle("createAd.nextButton.title".localized(), for: .normal)
        self.previewButton.setTitle("addContent.previewButton.title".localized(), for: .normal)
        self.questionTextView.text = "addQuestions.questionTextField.placeholder".localized()
        self.answerTypeLabel.text = "addQuestions.answerType.text".localized()
        self.answersLabel.text = "addQuestions.answers.text".localized()
        self.answersRequiredLabel.text = "addQuestions.answersRequired.text".localized()
        self.answersRequiredTextField.placeholder = "addQuestions.answersRequired.placeholder".localized()
    }
    
    func setupData() {
        AdBuilderManager.shared.fetchQuestionTypes { (questionTypes) in
            guard questionTypes.count > 0 else { return }
            self.questionTypes = questionTypes
            
            if self.questionNumber == 1 {
                self.answerTypeTextField.questionType = self.questionTypes.first
                self.drawInputUI(questionType: self.questionTypes.first!)
            } else {
                self.answerTypeTextField.questionType = nil
            }
        }
    }
    
    @objc func questionSwitchToggled(sender: UISwitch) {
        if sender.isOn {
            self.questionTextView.text = "addQuestions.questionTextField.placeholder".localized()
            self.questionTextView.isUserInteractionEnabled = true
            self.answersContainerView.isHidden = false
            self.answersContainerView.isUserInteractionEnabled = true
            self.answerTypeTextField.isEnabled = true
            
            guard self.questionTypes.count > 0 else { return }
            self.answerTypeTextField.questionType = self.questionTypes.first
            self.drawInputUI(questionType: self.questionTypes.first!)
        } else {
            self.questionTextView.text = ""
            self.questionTextView.isUserInteractionEnabled = false
            self.answersContainerView.isHidden = true
            self.answersContainerView.isUserInteractionEnabled = false
            self.answerTypeTextField.isEnabled = false
            
            self.answerTypeTextField.questionType = nil
        }
    }
    
    @IBAction func previewButtonPressed(sender: JifflrButton) {

    }
    
    @IBAction func nextButtonPressed(sender: JifflrButton) {
        
        self.validateInput(sender: sender) { (success) in
            guard success == true else {
                self.displayError(error: ErrorMessage.addContent)
                return
            }
            
            if self.answerTypeTextField.questionType != nil && self.questionNumber < 3 {
                let newQuestionNumber = self.questionNumber + 1
                let vc = AddQuestionsViewController.instantiateFromStoryboard(advert: self.advert, questionNumber: newQuestionNumber)
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                return
            }
        }
    }
    
    func validateInput(sender: JifflrButton, completion: @escaping (Bool) -> Void) {
        if self.questionNumber != 1 && self.answerTypeTextField.questionType == nil {
            completion(false)
            return
        }
        
        guard let questionType = self.answerTypeTextField.questionType,
            let questionText = self.questionTextView.text, !questionText.isEmpty,
            self.questionTextView.textColor == UIColor.mainBlue else {
            completion(false)
            return
        }
        
        switch questionType.type {
        case AdvertQuestionType.MultipleChoice:
            let valid = self.validateMultipleChoice(questionType: questionType, questionText: questionText)
            completion(valid)
        case AdvertQuestionType.NumberPicker:
            let valid = self.validateNumber(questionType: questionType, questionText: questionText)
            completion(valid)
        case AdvertQuestionType.TimePicker:
            let valid = self.validateDate(questionType: questionType, questionText: questionText)
            completion(valid)
        case AdvertQuestionType.DatePicker:
            let valid = self.validateDate(questionType: questionType, questionText: questionText)
            completion(valid)
        default:
            sender.animate()
            self.setupDefaultQuestionType(questionType: questionType, questionText: questionText) { (success) in
                sender.stopAnimating()
                completion(success)
            }
        }
    }
    
    func validateDate(questionType: QuestionType, questionText: String) -> Bool {
        guard let startDateText = self.minTextField.text, !startDateText.isEmpty else { return false }
        guard let endDateText = self.maxTextField.text, !endDateText.isEmpty else { return false }
        
        let dateFormatter = DateFormatter()
        let format = questionType.type == AdvertQuestionType.DatePicker ? "dd/MM/yyyy" : "HH:mm"
        dateFormatter.dateFormat = format
        
        guard let startDate = dateFormatter.date(from: startDateText) else { return false }
        guard let endDate = dateFormatter.date(from: endDateText) else { return false }
        guard endDate > startDate else { return false }
        
        let startAnswer = AdBuilderManager.shared.createAnswer(index: 0, content: startDate)
        let endAnswer = AdBuilderManager.shared.createAnswer(index: 1, content: endDate)
        let question = AdBuilderManager.shared.createQuestion(index: self.questionNumber, text: questionText, type: questionType)
        question.setAnswers(answers: [startAnswer, endAnswer])
        self.advert.addQuestion(question: question)
        
        return true
    }
    
    func validateNumber(questionType: QuestionType, questionText: String) -> Bool {
        guard let firstNumberText = self.minTextField.text, !firstNumberText.isEmpty else { return false }
        guard let lastNumberText = self.maxTextField.text, !lastNumberText.isEmpty else { return false }
        guard let firstNumber = Int(firstNumberText) else { return false }
        guard let lastNumber = Int(lastNumberText) else { return false }
        guard lastNumber > firstNumber else { return false }
        
        let firstAnswer = AdBuilderManager.shared.createAnswer(index: 0, content: firstNumber)
        let lastAnswer = AdBuilderManager.shared.createAnswer(index: 1, content: lastNumber)
        let question = AdBuilderManager.shared.createQuestion(index: self.questionNumber, text: questionText, type: questionType)
        question.setAnswers(answers: [firstAnswer, lastAnswer])
        self.advert.addQuestion(question: question)
        
        return true
    }
    
    func validateMultipleChoice(questionType: QuestionType, questionText: String) -> Bool {
        let firstAnswerText = self.minTextField.text
        let secondAnswerText = self.maxTextField.text
        let thirdAnswerText = self.answer3TextField.text
        let fourthAnswerText = self.answer4TextField.text
        let fifthAnswerText = self.answer5TextField.text
        
        guard let answer = firstAnswerText, !answer.isEmpty else {
            return false
        }
        
        var answerCount = 0
        let answers = [firstAnswerText, secondAnswerText, thirdAnswerText, fourthAnswerText, fifthAnswerText]
        for answer in answers {
            if let answer = answer, !answer.isEmpty {
                answerCount += 1
            }
        }
        
        guard let requiredAnswersText = self.answersRequiredTextField.text, !requiredAnswersText.isEmpty else { return false }
        guard let requiredAnswers = Int(requiredAnswersText) else { return false }
        guard requiredAnswers > 0 && requiredAnswers <= answerCount else { return false }
        
        var index = 0
        var answerObjects:[Answer] = []
        for answer in answers {
            if let answer = answer, !answer.isEmpty {
                index += 1
                let answerObject = AdBuilderManager.shared.createAnswer(index: index, content: answer)
                answerObjects.append(answerObject)
            }
        }
        
        let question = AdBuilderManager.shared.createQuestion(index: self.questionNumber, text: questionText, type: questionType)
        question.setAnswers(answers: answerObjects)
        self.advert.addQuestion(question: question)
        
        return true
    }
    
    func setupDefaultQuestionType(questionType: QuestionType, questionText: String, completion: @escaping (Bool) -> Void) {
        AdBuilderManager.shared.fetchDefaultAnswers(questionType: questionType) { (answers) in
            guard answers.count > 0 else {
                self.displayError(error: ErrorMessage.fetchAnswersFailed)
                completion(false)
                return
            }
            
            let question = AdBuilderManager.shared.createQuestion(index: self.questionNumber, text: questionText, type: questionType)
            question.setAnswers(answers: answers)
            self.advert.addQuestion(question: question)
            
            completion(true)
        }
    }
}

extension AddQuestionsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func createInputViews() {
        self.pickerView = UIPickerView()
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.answerTypeTextField.inputView = self.pickerView
        
        let toolbar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: 44.0))
        toolbar.barStyle = UIBarStyle.default
        let closeButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.pickerCloseButtonPressed))
        toolbar.items = [closeButton]
        self.answerTypeTextField.inputAccessoryView = toolbar
    }
    
    @objc func pickerCloseButtonPressed() {
        let selectedIndex = self.pickerView.selectedRow(inComponent: 0)
        self.answerTypeTextField.questionType = self.questionTypes[selectedIndex]
        self.answerTypeTextField.resignFirstResponder()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.questionTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.questionTypes[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.answerTypeTextField.questionType = self.questionTypes[row]
        self.drawInputUI(questionType: self.questionTypes[row])
    }
}
