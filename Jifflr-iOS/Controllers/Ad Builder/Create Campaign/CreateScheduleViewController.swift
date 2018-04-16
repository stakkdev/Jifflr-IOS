//
//  CreateScheduleViewController.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 13/04/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit

class CreateScheduleViewController: BaseViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var campaignNameLabel: UILabel!
    @IBOutlet weak var campaignNameTextField: JifflrTextField!
    @IBOutlet weak var advertLabel: UILabel!
    @IBOutlet weak var advertTextField: JifflrTextFieldDropdown!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dateToLabel: UILabel!
    @IBOutlet weak var dateFromTextField: JifflrTextFieldDate!
    @IBOutlet weak var dateToTextField: JifflrTextFieldDate!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeToLabel: UILabel!
    @IBOutlet weak var timeFromTextField: JifflrTextFieldDate!
    @IBOutlet weak var timeToTextField: JifflrTextFieldDate!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var nextButton: JifflrButton!
    @IBOutlet weak var helpButton: JifflrButton!
    @IBOutlet weak var helpButtonBottom: NSLayoutConstraint!
    @IBOutlet weak var daysLabel: UILabel!
    
    var pickerView: UIPickerView!
    var adverts:[Advert] = [] {
        didSet {
            self.pickerView.reloadAllComponents()
        }
    }
    var selectedAdvert: Advert!
    
    var advert: Advert!
    var days = ["M", "T", "W", "T", "F", "S", "S"]
    var selectedDays:[Int] = []
    
    class func instantiateFromStoryboard(advert: Advert) -> CreateScheduleViewController {
        let storyboard = UIStoryboard(name: "CreateCampaign", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CreateScheduleViewController") as! CreateScheduleViewController
        vc.advert = advert
        vc.selectedAdvert = advert
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        self.setupData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.collectionView.layoutIfNeeded()
        let height = self.collectionView.collectionViewLayout.collectionViewContentSize.height
        self.collectionViewHeight.constant = height
        self.view.layoutIfNeeded()
    }
    
    func setupUI() {
        self.setupLocalization()
        self.createInputViews()
        
        self.setBackgroundImage(image: UIImage(named: "MainBackground"))
        self.nextButton.setBackgroundColor(color: UIColor.mainPink)
        self.helpButton.setBackgroundColor(color: UIColor.mainBlueTransparent80)
        self.advertTextField.text = self.advert.details?.name
        
        self.dateFromTextField.addLeftImage(image: UIImage(named: "AnswerDropdown")!)
        self.dateFromTextField.dateFormat = "dd/MM/yy"
        self.dateToTextField.addLeftImage(image: UIImage(named: "AnswerDropdown")!)
        self.dateToTextField.dateFormat = "dd/MM/yy"
        self.timeFromTextField.addLeftImage(image: UIImage(named: "AnswerDropdown")!)
        self.timeFromTextField.dateFormat = "HH:mm"
        self.timeToTextField.addLeftImage(image: UIImage(named: "AnswerDropdown")!)
        self.timeToTextField.dateFormat = "HH:mm"
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.setHidesBackButton(false, animated: false)
        
        if Constants.isSmallScreen {
            self.helpButtonBottom.isActive = false
            self.scrollView.isScrollEnabled = true
        } else {
            self.helpButtonBottom.isActive = true
            self.scrollView.isScrollEnabled = false
        }
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    func setupLocalization() {
        self.title = "createSchedule.navigation.title".localized()
        self.campaignNameLabel.text = "createSchedule.campaignName.heading".localized()
        self.campaignNameTextField.placeholder = "createSchedule.campaignName.placeholder".localized()
        self.advertLabel.text = "createSchedule.advert.heading".localized()
        self.dateLabel.text = "createSchedule.date.heading".localized()
        self.timeLabel.text = "createSchedule.time.heading".localized()
        self.daysLabel.text = "createSchedule.days.heading".localized()
        self.dateToLabel.text = "createSchedule.toLabel.text".localized()
        self.timeToLabel.text = "createSchedule.toLabel.text".localized()
        self.nextButton.setTitle("createAd.nextButton.title".localized(), for: .normal)
        self.setupHelpButtonAttributedTitle()
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
        MyAdsManager.shared.fetchUserAds { (adverts) in
            self.adverts = adverts
        }
    }
    
    func createInputViews() {
        self.pickerView = UIPickerView()
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.advertTextField.inputView = self.pickerView
        
        let toolbar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: 44.0))
        toolbar.barStyle = UIBarStyle.default
        let closeButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.pickerCloseButtonPressed))
        toolbar.items = [closeButton]
        self.advertTextField.inputAccessoryView = toolbar
    }
    
    @objc func pickerCloseButtonPressed() {
        guard self.adverts.count > 0 else { return }
        let selectedIndex = self.pickerView.selectedRow(inComponent: 0)
        self.advertTextField.text = self.adverts[selectedIndex].details?.name
        self.selectedAdvert = self.adverts[selectedIndex]
        self.advertTextField.resignFirstResponder()
    }
    
    @IBAction func nextButtonPressed(sender: UIButton) {
        let campaign = Campaign()
        guard self.validateInput(campaign: campaign) else {
            self.displayError(error: ErrorMessage.addContent)
            return
        }
        
        let vc = CreateTargetViewController.instantiateFromStoryboard(campaign: campaign)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func validateInput(campaign: Campaign) -> Bool {
        guard let campaignName = self.campaignNameTextField.text, !campaignName.isEmpty else { return false }
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = self.dateFromTextField.dateFormat
        guard let dateFrom = dateFormatter.date(from: self.dateFromTextField.text!) else { return false }
        dateFormatter.dateFormat = self.timeFromTextField.dateFormat
        guard let timeFrom = dateFormatter.date(from: self.timeFromTextField.text!) else { return false }
        guard let startDate = CampaignManager.shared.mergeDates(date: dateFrom, time: timeFrom) else { return false }
        
        dateFormatter.dateFormat = self.dateToTextField.dateFormat
        guard let dateTo = dateFormatter.date(from: self.dateToTextField.text!) else { return false }
        dateFormatter.dateFormat = self.timeToTextField.dateFormat
        guard let timeTo = dateFormatter.date(from: self.timeToTextField.text!) else { return false }
        guard let endDate = CampaignManager.shared.mergeDates(date: dateTo, time: timeTo) else { return false }
        guard endDate > startDate else { return false }
        
        guard self.selectedDays.count > 0 else { return false }
        
        let schedule = Schedule()
        schedule.startDate = startDate
        schedule.endDate = endDate
        schedule.daysOfWeek = self.selectedDays
        campaign.schedule = schedule
        campaign.advert = self.selectedAdvert
        campaign.name = campaignName
        
        return true
    }
    
    @IBAction func helpButtonPressed(sender: UIButton) {
        self.navigationController?.pushViewController(FAQViewController.instantiateFromStoryboard(), animated: true)
    }
}

extension CreateScheduleViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.days.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DayCell", for: indexPath) as! DayCell
        cell.titleLabel.text = self.days[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard !Constants.isSmallScreen else { return CGSize(width: 40.0, height: 40.0) }
        
        let totalWidth = UIScreen.main.bounds.width - 36.0
        let spacingWidth = 10.0 * CGFloat(self.days.count)
        let availableWidth = totalWidth - spacingWidth
        let width = availableWidth / CGFloat(self.days.count)
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? DayCell {
            if cell.roundedView.tag == 0 {
                self.setCellSelected(cell: cell, indexPath: indexPath)
            } else {
                self.setCellUnselected(cell: cell, indexPath: indexPath)
            }
        }
    }
    
    func setCellSelected(cell: DayCell, indexPath: IndexPath) {
        cell.roundedView.tag = 1
        cell.roundedView.backgroundColor = UIColor.mainOrange
        cell.titleLabel.textColor = UIColor.white
        cell.titleLabel.font = UIFont(name: Constants.FontNames.GothamBold, size: 20.0)
        
        self.selectedDays.append(indexPath.row)
    }
    
    func setCellUnselected(cell: DayCell, indexPath: IndexPath) {
        cell.roundedView.tag = 0
        cell.roundedView.backgroundColor = UIColor.white
        cell.titleLabel.textColor = UIColor.mainBlue
        cell.titleLabel.font = UIFont(name: Constants.FontNames.GothamBook, size: 20.0)
        
        if let index = self.selectedDays.index(of: indexPath.row) {
            self.selectedDays.remove(at: index)
        }
    }
}

extension CreateScheduleViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.adverts.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.adverts[row].details?.name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.advertTextField.text = self.adverts[row].details?.name
        self.selectedAdvert = self.adverts[row]
    }
}
