//
//  AddQuestionsViewController.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 03/04/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit

class AddQuestionsViewController: BaseViewController {
    
    @IBOutlet weak var previewButton: JifflrButton!
    @IBOutlet weak var nextButton: JifflrButton!
    @IBOutlet weak var questionTextView: JifflrTextView!
    @IBOutlet weak var answerTypeLabel: UILabel!
    @IBOutlet weak var answerTypeTextField: JifflrTextFieldDropdown!
    @IBOutlet weak var answersLabel: UILabel!
    @IBOutlet weak var answersContainerView: UIView!
    
    var pickerView: UIPickerView!
    
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
    }
    
    func setupData() {
        AdBuilderManager.shared.fetchQuestionTypes { (questionTypes) in
            guard questionTypes.count > 0 else { return }
            self.questionTypes = questionTypes
        }
    }
    
    @objc func questionSwitchToggled(sender: UISwitch) {
        if sender.isOn {
            self.questionTextView.text = "addQuestions.questionTextField.placeholder".localized()
            self.questionTextView.isUserInteractionEnabled = true
            self.answersContainerView.isHidden = false
            self.answersContainerView.isUserInteractionEnabled = true
        } else {
            self.questionTextView.text = ""
            self.questionTextView.isUserInteractionEnabled = false
            self.answersContainerView.isHidden = true
            self.answersContainerView.isUserInteractionEnabled = false
        }
    }
    
    @IBAction func previewButtonPressed(sender: UIButton) {

    }
    
    @IBAction func nextButtonPressed(sender: UIButton) {

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
        self.answerTypeTextField.text = self.questionTypes[selectedIndex].name
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
        self.answerTypeTextField.text = self.questionTypes[row].name
    }
}
