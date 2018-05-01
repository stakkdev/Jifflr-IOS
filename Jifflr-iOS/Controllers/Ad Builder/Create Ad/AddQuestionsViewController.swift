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
    @IBOutlet var nextButtonTopUrls: NSLayoutConstraint!
    @IBOutlet var nextButtonTopAnswers: NSLayoutConstraint!
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
    
    @IBOutlet weak var urlsContainerView: UIView!
    @IBOutlet weak var websiteLabel: UILabel!
    @IBOutlet weak var websiteTextField: JifflrTextField!
    @IBOutlet weak var facebookLabel: UILabel!
    @IBOutlet weak var facebookTextField: JifflrTextField!
    @IBOutlet weak var twitterLabel: UILabel!
    @IBOutlet weak var twitterTextField: JifflrTextField!
    @IBOutlet weak var onlineStoreLabel: UILabel!
    @IBOutlet weak var onlineStoreTextField: JifflrTextField!
    @IBOutlet weak var appStoreLabel: UILabel!
    @IBOutlet weak var appStoreTextField: JifflrTextField!
    @IBOutlet weak var playStoreLabel: UILabel!
    @IBOutlet weak var playStoreTextField: JifflrTextField!
    
    var pickerView: UIPickerView!
    var datePicker: UIDatePicker!
    
    var advert: Advert!
    var questionTypes: [QuestionType] = [] {
        didSet {
            self.handleQuestionTypesFetch()
        }
    }
    
    var questionNumber = 0
    var previewContent:[(question: Question, answers: [Answer])] = []
    var content:[(question: Question, answers: [Answer])] = []

    class func instantiateFromStoryboard(advert: Advert, questionNumber: Int, content: [(question: Question, answers: [Answer])]) -> AddQuestionsViewController {
        let storyboard = UIStoryboard(name: "CreateAd", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AddQuestionsViewController") as! AddQuestionsViewController
        vc.advert = advert
        vc.questionNumber = questionNumber
        vc.content = content
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        self.setupData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.previewContent = []
    }
    
    func setupUI() {
        self.setupLocalization()
        self.setBackgroundImage(image: UIImage(named: "MainBackground"))
        
        self.urlsContainerView.backgroundColor = UIColor.clear
        self.websiteTextField.addLeftView(image: UIImage(named: "URLAdBuilderWebsite"))
        self.facebookTextField.addLeftView(image: UIImage(named: "URLAdBuilderFacebook"))
        self.twitterTextField.addLeftView(image: UIImage(named: "URLAdBuilderTwitter"))
        self.onlineStoreTextField.addLeftView(image: UIImage(named: "URLAdBuilderOnlineStore"))
        self.appStoreTextField.addLeftView(image: UIImage(named: "URLAdBuilderAppStore"))
        self.playStoreTextField.addLeftView(image: UIImage(named: "URLAdBuilderPlayStore"))
        
        self.nextButton.setBackgroundColor(color: UIColor.mainPink)
        self.previewButton.setBackgroundColor(color: UIColor.mainBlueTransparent80)
        
        self.questionTextView.textContainer.maximumNumberOfLines = 3
        self.questionTextView.textContainer.lineBreakMode = .byTruncatingTail
        
        self.answersContainerView.isHidden = true
        self.urlsContainerView.isHidden = true
        
        let questionSwitch = UISwitch()
        questionSwitch.addTarget(self, action: #selector(self.questionSwitchToggled(sender:)), for: .valueChanged)
        questionSwitch.onTintColor = UIColor.mainOrange
        questionSwitch.backgroundColor = UIColor.offSwitchGrey
        questionSwitch.layer.cornerRadius = 16.0
        let switchBarButton = UIBarButtonItem(customView: questionSwitch)
        self.navigationItem.rightBarButtonItem = switchBarButton
        
        questionSwitch.isOn = true
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
        self.websiteLabel.text = "addQuestions.website.heading".localized()
        self.facebookLabel.text = "addQuestions.facebook.heading".localized()
        self.twitterLabel.text = "addQuestions.twitter.heading".localized()
        self.onlineStoreLabel.text = "addQuestions.onlineStore.heading".localized()
        self.appStoreLabel.text = "addQuestions.appStore.heading".localized()
        self.playStoreLabel.text = "addQuestions.playStore.heading".localized()
    }
    
    func setupData() {
        if Reachability.isConnectedToNetwork() {
            self.updateServerData()
        } else {
            self.updateLocalData()
        }
    }
    
    func updateServerData() {
        AdBuilderManager.shared.fetchQuestionTypes(local: false) { (questionTypes) in
            guard questionTypes.count > 0 else {
                self.updateLocalData()
                return
            }
            
            self.questionTypes = questionTypes
        }
    }
    
    func updateLocalData() {
        AdBuilderManager.shared.fetchQuestionTypes(local: true) { (questionTypes) in
            guard questionTypes.count > 0 else {
                self.displayError(error: ErrorMessage.questionTypeFetchFailed)
                return
            }
            
            self.questionTypes = questionTypes
        }
    }
    
    func handleQuestionTypesFetch() {
        if self.content.indices.contains(self.questionNumber - 1) {
            let question = self.content[self.questionNumber - 1].question
            self.questionTextView.text = question.text
            self.questionTextView.textColor = UIColor.mainBlue
            let questionType = self.content[self.questionNumber - 1].question.type
            self.answerTypeTextField.questionType = questionType
            self.drawInputUI(questionType: questionType)
            self.drawQuestionData(questionType: questionType)
        } else {
            self.answerTypeTextField.questionType = self.questionTypes.first
            self.drawInputUI(questionType: self.questionTypes.first!)
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
            self.urlsContainerView.isHidden = true
            self.answerTypeTextField.isEnabled = false
            
            self.answerTypeTextField.questionType = nil
        }
    }
    
    @IBAction func previewButtonPressed(sender: JifflrButton) {
        guard let questionType = self.answerTypeTextField.questionType else { return }
        
        self.validateInput(sender: sender) { (success) in
            guard success == true, self.previewContent.count > 0 else {
                self.displayError(error: ErrorMessage.addContent)
                return
            }
            
            var controller: UIViewController!
            
            switch questionType.type {
            case AdvertQuestionType.Binary:
                controller = BinaryFeedbackViewController.instantiateFromStoryboard(advert: self.advert, content: self.previewContent, questionAnswers: [], mode: AdViewMode.preview)
            case AdvertQuestionType.DatePicker:
                controller = DateTimeFeedbackViewController.instantiateFromStoryboard(advert: self.advert, content: self.previewContent, questionAnswers: [], isTime: false, mode: AdViewMode.preview)
            case AdvertQuestionType.MultipleChoice, AdvertQuestionType.Month, AdvertQuestionType.DayOfWeek:
                controller = MultiSelectFeedbackViewController.instantiateFromStoryboard(advert: self.advert, content: self.previewContent, questionAnswers: [], mode: AdViewMode.preview)
            case AdvertQuestionType.NumberPicker:
                controller = NumberPickerFeedbackViewController.instantiateFromStoryboard(advert: self.advert, content: self.previewContent, questionAnswers: [], mode: AdViewMode.preview)
            case AdvertQuestionType.Rating:
                controller = ScaleFeedbackViewController.instantiateFromStoryboard(advert: self.advert, content: self.previewContent, questionAnswers: [], mode: AdViewMode.preview)
            case AdvertQuestionType.TimePicker:
                controller = DateTimeFeedbackViewController.instantiateFromStoryboard(advert: self.advert, content: self.previewContent, questionAnswers: [], isTime: true, mode: AdViewMode.preview)
            case AdvertQuestionType.URLLinks:
                controller = URLFeedbackViewController.instantiateFromStoryboard(advert: self.advert, content: self.previewContent, questionAnswers: [], mode: AdViewMode.preview)
            default:
                return
            }
            
            let navController = UINavigationController(rootViewController: controller)
            navController.isNavigationBarHidden = true
            self.navigationController?.present(navController, animated: true, completion: nil)
        }
    }
    
    @IBAction func nextButtonPressed(sender: JifflrButton) {
        
        if self.answerTypeTextField.questionType == nil {
            let vc = AdCreatedViewController.instantiateFromStoryboard(advert: self.advert, content: self.content)
            self.navigationController?.pushViewController(vc, animated: true)
            return
        }
        
        self.validateInput(sender: sender) { (success) in
            guard success == true else {
                self.displayError(error: ErrorMessage.addContent)
                return
            }
            
            if self.questionNumber < 3 {
                let number = self.questionNumber + 1
                let vc = AddQuestionsViewController.instantiateFromStoryboard(advert: self.advert, questionNumber: number, content: self.content)
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                let vc = AdCreatedViewController.instantiateFromStoryboard(advert: self.advert, content: self.content)
                self.navigationController?.pushViewController(vc, animated: true)
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
        
        self.previewContent = []
        
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
        case AdvertQuestionType.URLLinks:
            let valid = self.validateUrls(questionType: questionType, questionText: questionText)
            completion(valid)
        default:
            sender.animate()
            self.setupDefaultQuestionType(questionType: questionType, questionText: questionText) { (success) in
                sender.stopAnimating()
                completion(success)
            }
        }
    }
    
    func validateUrls(questionType: QuestionType, questionText: String) -> Bool {
        guard let website = self.websiteTextField.text, website.isUrl() else { return false }
        guard let facebook = self.facebookTextField.text, facebook.isUrl() else { return false }
        guard let twitter = self.twitterTextField.text, twitter.isUrl() else { return false }
        guard let onlineStore = self.onlineStoreTextField.text, onlineStore.isUrl() else { return false }
        guard let appStore = self.appStoreTextField.text, appStore.isUrl() else { return false }
        guard let playStore = self.playStoreTextField.text, playStore.isUrl() else { return false }
        
        let websiteAnswer = AdBuilderManager.shared.createAnswer(index: 0, content: website)
        let facebookAnswer = AdBuilderManager.shared.createAnswer(index: 1, content: facebook)
        let twitterAnswer = AdBuilderManager.shared.createAnswer(index: 2, content: twitter)
        let onlineStoreAnswer = AdBuilderManager.shared.createAnswer(index: 3, content: onlineStore)
        let appStoreAnswer = AdBuilderManager.shared.createAnswer(index: 4, content: appStore)
        let playStoreAnswer = AdBuilderManager.shared.createAnswer(index: 5, content: playStore)
        
        let number = self.questionNumber
        let question = AdBuilderManager.shared.createQuestion(index: number, text: questionText, type: questionType, noOfRequiredAnswers: nil)
        let answers = [websiteAnswer, facebookAnswer, twitterAnswer, onlineStoreAnswer, appStoreAnswer, playStoreAnswer]
        
        self.insertContent(question: question, answers: answers)
        self.previewContent.append((question: question, answers: answers))
        
        return true
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
        let question = AdBuilderManager.shared.createQuestion(index: self.questionNumber, text: questionText, type: questionType, noOfRequiredAnswers: nil)
        let answers = [startAnswer, endAnswer]
        
        self.insertContent(question: question, answers: answers)
        self.previewContent.append((question: question, answers: [startAnswer, endAnswer]))
        
        return true
    }
    
    func validateNumber(questionType: QuestionType, questionText: String) -> Bool {
        guard let firstNumberText = self.minTextField.text, !firstNumberText.isEmpty else { return false }
        guard let lastNumberText = self.maxTextField.text, !lastNumberText.isEmpty else { return false }
        guard let firstNumber = Int(firstNumberText) else { return false }
        guard let lastNumber = Int(lastNumberText) else { return false }
        guard lastNumber > firstNumber else { return false }
        
        let firstAnswer = AdBuilderManager.shared.createAnswer(index: 0, content: firstNumberText)
        let lastAnswer = AdBuilderManager.shared.createAnswer(index: 1, content: lastNumberText)
        let question = AdBuilderManager.shared.createQuestion(index: self.questionNumber, text: questionText, type: questionType, noOfRequiredAnswers: nil)
        let answers = [firstAnswer, lastAnswer]
        
        self.insertContent(question: question, answers: answers)
        self.previewContent.append((question: question, answers: [firstAnswer, lastAnswer]))
        
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
        
        let question = AdBuilderManager.shared.createQuestion(index: self.questionNumber, text: questionText, type: questionType, noOfRequiredAnswers: requiredAnswers)
        
        self.insertContent(question: question, answers: answerObjects)
        self.previewContent.append((question: question, answers: answerObjects))
        
        return true
    }
    
    func setupDefaultQuestionType(questionType: QuestionType, questionText: String, completion: @escaping (Bool) -> Void) {
        AdBuilderManager.shared.fetchDefaultAnswers(questionType: questionType) { (answers) in
            guard answers.count > 0 else {
                self.displayError(error: ErrorMessage.fetchAnswersFailed)
                completion(false)
                return
            }
            
            let question = AdBuilderManager.shared.createQuestion(index: self.questionNumber, text: questionText, type: questionType, noOfRequiredAnswers: nil)
            
            self.insertContent(question: question, answers: answers)
            self.previewContent.append((question: question, answers: answers))
            
            completion(true)
        }
    }
    
    func insertContent(question: Question, answers: [Answer]) {
        let index = self.questionNumber - 1
        if self.content.indices.contains(index) {
            self.content.remove(at: index)
        }
        
        self.content.insert((question: question, answers: answers), at: index)
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
        let flexibleSpacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.items = [flexibleSpacer, closeButton]
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
