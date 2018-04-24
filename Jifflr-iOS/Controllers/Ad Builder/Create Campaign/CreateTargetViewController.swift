//
//  CreateTargetViewController.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 16/04/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit
import TTRangeSlider

class CreateTargetViewController: BaseViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nextButton: JifflrButton!
    @IBOutlet weak var helpButton: JifflrButton!
    @IBOutlet weak var helpButtonBottom: NSLayoutConstraint!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var genderSegmentedControl: GenderSegmentedControl!
    @IBOutlet weak var agesLabel: UILabel!
    @IBOutlet weak var agesSlider: TTRangeSlider!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var locationTextField: JifflrTextFieldDropdown!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var languageTextField: JifflrTextFieldDropdown!
    @IBOutlet weak var audienceHeadingLabel: UILabel!
    @IBOutlet weak var audienceLabel: UILabel!
    
    var campaign: Campaign!
    
    var locations: [Location] = [] {
        didSet {
            self.locationPickerView.reloadAllComponents()
        }
    }
    var selectedLocation: Location?
    var locationPickerView: UIPickerView!
    
    var languages: [Language] = [] {
        didSet {
            self.languagePickerView.reloadAllComponents()
        }
    }
    var selectedLanguage: Language?
    var languagePickerView: UIPickerView!
    
    var genders:[Gender] = []
    
    var isEdit = false

    class func instantiateFromStoryboard(campaign: Campaign, isEdit: Bool) -> CreateTargetViewController {
        let storyboard = UIStoryboard(name: "CreateCampaign", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CreateTargetViewController") as! CreateTargetViewController
        vc.campaign = campaign
        vc.isEdit = isEdit
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        self.setupData()
        self.setupEditData()
    }
    
    func setupUI() {
        self.setupLocalization()
        
        self.setBackgroundImage(image: UIImage(named: "MainBackground"))
        self.nextButton.setBackgroundColor(color: UIColor.mainPink)
        self.helpButton.setBackgroundColor(color: UIColor.mainBlueTransparent80)
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.setHidesBackButton(false, animated: false)
        
        if Constants.isSmallScreen {
            self.helpButtonBottom.isActive = false
            self.scrollView.isScrollEnabled = true
        } else {
            self.helpButtonBottom.isActive = true
            self.scrollView.isScrollEnabled = false
        }
        
        self.agesSlider.handleColor = UIColor.mainOrange
        self.agesSlider.lineHeight = 4.0
        self.agesSlider.tintColorBetweenHandles = UIColor.mainOrange
        self.agesSlider.tintColor = UIColor.white
        self.agesSlider.handleDiameter = 28.0
        self.agesSlider.delegate = self
        
        self.createLocationInputViews()
        self.createLanguageInputViews()
    }
    
    func setupLocalization() {
        self.title = "createTarget.navigation.title".localized()
        self.genderLabel.text = "createTarget.gender.heading".localized()
        self.locationLabel.text = "createTarget.location.heading".localized()
        self.languageLabel.text = "createTarget.language.heading".localized()
        self.audienceHeadingLabel.text = "createTarget.audienceSize.heading".localized()
        self.setupHelpButtonAttributedTitle()
        
        if self.isEdit {
            self.nextButton.setTitle("createSchedule.saveButton.title".localized(), for: .normal)
        } else {
            self.nextButton.setTitle("createAd.nextButton.title".localized(), for: .normal)
            self.agesLabel.text = "createTarget.ages.heading".localizedFormat(18, 35)
        }
    }
    
    func setupHelpButtonAttributedTitle() {
        let title = "dashboard.helpButton.title".localized()
        let helpWords = title.components(separatedBy: " ")
        guard helpWords.count > 1, let lastWord = helpWords.last else {
            self.helpButton.setTitle(title, for: .normal)
            return
        }
        
        let range = (title as NSString).range(of: lastWord)
        guard range.location != NSNotFound else {
            self.helpButton.setTitle(title, for: .normal)
            return
        }
        
        let font = UIFont(name: Constants.FontNames.GothamBold, size: 20)!
        let attributes = [NSAttributedStringKey.font: font, NSAttributedStringKey.foregroundColor: UIColor.white]
        let attributedString = NSMutableAttributedString(string: title, attributes: attributes)
        attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.mainOrange, range: range)
        self.helpButton.setAttributedTitle(attributedString, for: .normal)
    }
    
    func setupData() {
        if !self.isEdit { self.locationTextField.animate() }
        LocationManager.shared.fetchLocations { (locations) in
            self.locationTextField.stopAnimating()
            
            guard locations.count > 0 else {
                self.displayError(error: ErrorMessage.locationFetchFailed)
                return
            }
            
            self.locations = locations
            
            if !self.isEdit {
                if let location = Session.shared.currentLocation {
                    self.locationTextField.text = location.name
                    self.selectedLocation = location
                } else {
                    self.locationTextField.text = locations.first?.name
                    self.selectedLocation = locations.first
                }
            }
        }
        
        if !self.isEdit { self.languageTextField.animate() }
        LanguageManager.shared.fetchLanguages { (languages) in
            self.languageTextField.stopAnimating()
            guard languages.count > 0 else {
                self.displayError(error: ErrorMessage.languageFetchFailed)
                return
            }
            
            self.languages = languages
            
            if !self.isEdit {
                self.languageTextField.text = languages.first?.name
                self.selectedLanguage = languages.first
            }
        }
        
        UserManager.shared.fetchGenders { (genders) in
            self.genders = genders
        }
    }
    
    func setupEditData() {
        guard self.isEdit else { return }
        guard let demographic = self.campaign.demographic else { return }
        
        if let gender = demographic.gender {
            self.genderSegmentedControl.selectedSegmentIndex = gender.index
        } else {
            self.genderSegmentedControl.selectedSegmentIndex = 2
        }
        
        self.agesSlider.selectedMinimum = Float(demographic.minAge)
        self.agesSlider.selectedMaximum = Float(demographic.maxAge)
        self.agesLabel.text = "createTarget.ages.heading".localizedFormat(Int(demographic.minAge), Int(demographic.maxAge))
        self.locationTextField.text = demographic.location.name
        self.selectedLocation = demographic.location
        self.languageTextField.text = demographic.language.name
        self.selectedLanguage = demographic.language
        self.audienceLabel.text = "\(demographic.estimatedAudience)"
    }
    
    @IBAction func nextButtonPressed(sender: UIButton) {
        guard self.validateInput() else {
            self.displayError(error: ErrorMessage.addContent)
            return
        }
        
        if self.isEdit {
            // Handle if the campaign is a previously saved object, or a copy.
            if let _ = self.campaign?.objectId {
                self.nextButton.animate()
                self.campaign.saveAndPin {
                    self.nextButton.stopAnimating()
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            self.nextButton.animate()
            CampaignManager.shared.fetchCostPerReview(location: self.campaign.demographic!.location) { (costPerReview, locationFinancial) in
                self.nextButton.stopAnimating()
                guard let costPerReview = costPerReview, let locationFinancial = locationFinancial else {
                    self.displayError(error: ErrorMessage.unknown)
                    return
                }
                
                self.campaign.costPerReview = costPerReview
                self.campaign.locationFinancial = locationFinancial
                let vc = CampaignOverviewViewController.instantiateFromStoryboard(campaign: self.campaign)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func validateInput() -> Bool {
        let minAge = self.agesSlider.selectedMinimum
        let maxAge = self.agesSlider.selectedMaximum
        guard let location = self.selectedLocation else { return false }
        guard let language = self.selectedLanguage else { return false }
        
        let demographic = self.campaign.demographic ?? Demographic()
        demographic.minAge = Int(minAge)
        demographic.maxAge = Int(maxAge)
        demographic.location = location
        demographic.language = language
        
        let genderIndex = self.genderSegmentedControl.selectedSegmentIndex
        if genderIndex < 2 {
            guard let gender = self.genders.first(where: { $0.index == genderIndex }) else { return false }
            demographic.gender = gender
        }
        
        if let text = self.audienceLabel.text, let audienceSize = Int(text) {
            demographic.estimatedAudience = audienceSize
        }
        
        self.campaign.demographic = demographic
        
        return true
    }
    
    @IBAction func helpButtonPressed(sender: UIButton) {
        self.navigationController?.pushViewController(FAQViewController.instantiateFromStoryboard(), animated: true)
    }
    
    @IBAction func genderChanged(sender: UISegmentedControl) {
        self.updateAudienceSize()
    }
    
    @IBAction func ageChanged(sender: TTRangeSlider) {
        self.updateAudienceSize()
    }
    
    func createLocationInputViews() {
        self.locationPickerView = UIPickerView()
        self.locationPickerView.delegate = self
        self.locationPickerView.dataSource = self
        self.locationTextField.inputView = self.locationPickerView
        
        let toolbar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: 44.0))
        toolbar.barStyle = UIBarStyle.default
        let closeButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.locationPickerCloseButtonPressed))
        toolbar.items = [closeButton]
        self.locationTextField.inputAccessoryView = toolbar
    }
    
    func createLanguageInputViews() {
        self.languagePickerView = UIPickerView()
        self.languagePickerView.delegate = self
        self.languagePickerView.dataSource = self
        self.languageTextField.inputView = self.languagePickerView
        
        let toolbar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: 44.0))
        toolbar.barStyle = UIBarStyle.default
        let closeButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.languagePickerCloseButtonPressed))
        toolbar.items = [closeButton]
        self.languageTextField.inputAccessoryView = toolbar
    }
    
    @objc func locationPickerCloseButtonPressed() {
        guard self.locations.count > 0 else { return }
        let selectedIndex = self.locationPickerView.selectedRow(inComponent: 0)
        self.locationTextField.text = self.locations[selectedIndex].name
        self.selectedLocation = self.locations[selectedIndex]
        self.locationTextField.resignFirstResponder()
        self.updateAudienceSize()
    }
    
    @objc func languagePickerCloseButtonPressed() {
        guard self.languages.count > 0 else { return }
        let selectedIndex = self.languagePickerView.selectedRow(inComponent: 0)
        self.languageTextField.text = self.languages[selectedIndex].name
        self.selectedLanguage = self.languages[selectedIndex]
        self.languageTextField.resignFirstResponder()
        self.updateAudienceSize()
    }
    
    func updateAudienceSize() {
        guard self.validateInput() else { return }
        guard let demographic = self.campaign.demographic else { return }
        
        CampaignManager.shared.estimatedAudienceSize(demographic: demographic) { (size) in
            guard let size = size else { return }
            self.audienceLabel.text = "\(size)"
        }
    }
}

extension CreateTargetViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == self.locationPickerView {
            return self.locations.count
        }
        
        return self.languages.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == self.locationPickerView {
            return self.locations[row].name
        }
        
        return self.languages[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == self.locationPickerView {
            self.locationTextField.text = self.locations[row].name
            self.selectedLocation = self.locations[row]
        } else {
            self.languageTextField.text = self.languages[row].name
            self.selectedLanguage = self.languages[row]
        }
    }
}

extension CreateTargetViewController: TTRangeSliderDelegate {
    func rangeSlider(_ sender: TTRangeSlider!, didChangeSelectedMinimumValue selectedMinimum: Float, andMaximumValue selectedMaximum: Float) {
        let min = Int(selectedMinimum)
        let max = Int(selectedMaximum)
        self.agesLabel.text = "createTarget.ages.heading".localizedFormat(min, max)
    }
}
