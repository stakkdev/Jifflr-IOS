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
    var selectedAdvert: Advert?

    var days = ["M", "T", "W", "T", "F", "S", "S"]
    var selectedDays:[Int] = [0, 1, 2, 3, 4, 5, 6]
    var availableDays:[Int] = [0, 1, 2, 3, 4, 5, 6]
    
    var isEdit = false
    var campaign: Campaign?
    
    class func instantiateFromStoryboard(advert: Advert?, campaign: Campaign?, isEdit: Bool) -> CreateScheduleViewController {
        let storyboard = UIStoryboard(name: "CreateCampaign", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CreateScheduleViewController") as! CreateScheduleViewController

        vc.selectedAdvert = advert
        vc.campaign = campaign
        vc.isEdit = isEdit
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
        self.advertTextField.text = self.selectedAdvert?.details?.name
        
        self.dateFromTextField.addLeftImage(image: UIImage(named: "ScheduleDate")!)
        self.dateFromTextField.minimumDate = true
        self.dateFromTextField.type = .dateFrom
        self.dateFromTextField.delegate = self
        
        self.dateToTextField.addLeftImage(image: UIImage(named: "ScheduleDate")!)
        self.dateToTextField.minimumDate = true
        self.dateToTextField.type = .dateTo
        self.dateToTextField.delegate = self
        
        self.timeFromTextField.addLeftImage(image: UIImage(named: "ScheduleTime")!)
        self.timeFromTextField.type = .timeFrom
        self.timeFromTextField.minimumDate = false
        
        self.timeToTextField.addLeftImage(image: UIImage(named: "ScheduleTime")!)
        self.timeToTextField.type = .timeTo
        self.timeToTextField.minimumDate = false
        
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
        
        if self.isEdit {
            self.nextButton.setTitle("createSchedule.saveButton.title".localized(), for: .normal)
        } else {
            self.nextButton.setTitle("createAd.nextButton.title".localized(), for: .normal)
        }
        
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
            
            if self.selectedAdvert == nil, adverts.count > 0 {
                self.selectedAdvert = adverts.first
                self.advertTextField.text = self.selectedAdvert?.details?.name
            }
        }
        
        guard let campaign = self.campaign else { return }
        self.campaignNameTextField.text = campaign.name
        
        guard let schedule = campaign.schedule else { return }
        self.dateFromTextField.text = CampaignManager.shared.dateString(date: schedule.startDate)
        self.dateToTextField.text = CampaignManager.shared.dateString(date: schedule.endDate)
        self.timeFromTextField.text = CampaignManager.shared.timeString(date: schedule.startDate)
        self.timeToTextField.text = CampaignManager.shared.timeString(date: schedule.endDate)
    }
    
    func createInputViews() {
        self.pickerView = UIPickerView()
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.advertTextField.inputView = self.pickerView
        
        let toolbar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: 44.0))
        toolbar.barStyle = UIBarStyle.default
        let closeButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.pickerCloseButtonPressed))
        let flexibleSpacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.items = [flexibleSpacer, closeButton]
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
        if self.isEdit {
            guard let campaign = self.campaign else { return }
            guard self.validateInput(campaign: campaign) else {
                self.displayError(error: ErrorMessage.addContent)
                return
            }
            
            // Handle if the campaign is a previously saved object, or a copy.
            if let _ = self.campaign?.objectId {
                self.nextButton.animate()
                campaign.saveAndPin {
                    self.nextButton.stopAnimating()
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            let campaign = Campaign()
            guard self.validateInput(campaign: campaign) else {
                self.displayError(error: ErrorMessage.addContent)
                return
            }
            
            let vc = CreateTargetViewController.instantiateFromStoryboard(campaign: campaign, isEdit: false)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func validateInput(campaign: Campaign) -> Bool {
        guard let selectedAdvert = self.selectedAdvert else { return false }
        guard let campaignName = self.campaignNameTextField.text, !campaignName.isEmpty else { return false }
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")!
        dateFormatter.dateFormat = "dd/MM/yyyy"
        guard let dateFrom = dateFormatter.date(from: self.dateFromTextField.text!) else { return false }
        dateFormatter.dateFormat = "HH:mm"
        guard let timeFrom = dateFormatter.date(from: self.timeFromTextField.text!) else { return false }
        guard let startDate = CampaignManager.shared.mergeDates(date: dateFrom, time: timeFrom) else { return false }
        
        dateFormatter.dateFormat = "dd/MM/yyyy"
        guard let dateTo = dateFormatter.date(from: self.dateToTextField.text!) else { return false }
        dateFormatter.dateFormat = "HH:mm"
        guard let timeTo = dateFormatter.date(from: self.timeToTextField.text!) else { return false }
        guard let endDate = CampaignManager.shared.mergeDates(date: dateTo, time: timeTo) else { return false }
        guard endDate > startDate else { return false }
        guard timeTo > timeFrom else { return false }
        
        guard self.selectedDays.count > 0 else { return false }
        
        if let schedule = self.campaign?.schedule {
            if campaign.advert.objectId != selectedAdvert.objectId {
                campaign.advert = selectedAdvert
            }
            
            if campaign.name != campaignName {
                campaign.name = campaignName
            }
            
            schedule.startDate = startDate
            schedule.endDate = endDate
            schedule.daysOfWeek = CampaignManager.shared.getDayOfWeekBitwiseInt(dayInts: self.selectedDays)
        } else {
            guard let minimumDate = Calendar.current.date(byAdding: .day, value: 1, to: Date()) else { return false }
            guard startDate >= minimumDate else { return false }
            
            let schedule = Schedule()
            schedule.startDate = startDate
            schedule.endDate = endDate
            schedule.daysOfWeek = CampaignManager.shared.getDayOfWeekBitwiseInt(dayInts: self.selectedDays)
            campaign.schedule = schedule
            campaign.advert = selectedAdvert
            campaign.name = campaignName
        }
        
        return true
    }
    
    @IBAction func helpButtonPressed(sender: UIButton) {
        self.navigationController?.pushViewController(FAQViewController.instantiateFromStoryboard(shouldSelectCampaigns: true), animated: true)
    }
    
    func getDaysBetweenDates() {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_GB")
        
        dateFormatter.dateFormat = "dd/MM/yyyy"
        guard let startDate = dateFormatter.date(from: self.dateFromTextField.text!) else { return }
        
        dateFormatter.dateFormat = "dd/MM/yyyy"
        guard let endDate = dateFormatter.date(from: self.dateToTextField.text!) else { return }
        
        guard let numberOfDays = Calendar.current.dateComponents([.day], from: startDate, to: endDate).day else { return }
        guard numberOfDays > 0 else {
            self.availableDays = []
            self.collectionView.reloadData()
            return
        }
        
        dateFormatter.dateFormat = "EEEE"
        let startDay = dateFormatter.string(from: startDate)
        let days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
        self.availableDays = []
        
        if let index = days.firstIndex(where: { $0 == startDay }) {
            self.availableDays.append(index)
            let startingIndex = index + 1
            let endIndex = startingIndex + numberOfDays - 1
            for i in startingIndex...endIndex {
                if !self.availableDays.contains(i) && i < 7  {
                    self.availableDays.append(i)
                }
            }
            
            let overlap = numberOfDays - (7 - startingIndex) - 1
            if overlap >= 0 {
                for i in 0...overlap {
                    if !self.availableDays.contains(i) && i < 7 {
                        self.availableDays.append(i)
                    }
                }
            }
        }
        
        self.collectionView.reloadData()
    }
}

extension CreateScheduleViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.getDaysBetweenDates()
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
        
        if let schedule = self.campaign?.schedule {
            let value = schedule.daysOfWeek
            let resultArray = Days.all.map { $0 & value }
            
            if self.availableDays.contains(indexPath.row) {
                if resultArray[indexPath.row] != 0 {
                    self.setCellSelected(cell: cell, indexPath: indexPath)
                } else {
                    self.setCellUnselected(cell: cell, indexPath: indexPath)
                }
            } else {
                self.setCellNotAvailable(cell: cell, indexPath: indexPath)
            }
        } else {
            if !self.availableDays.contains(indexPath.row) {
                self.setCellNotAvailable(cell: cell, indexPath: indexPath)
            } else {
                if !self.selectedDays.contains(indexPath.row) {
                    self.setCellUnselected(cell: cell, indexPath: indexPath)
                } else {
                    self.setCellSelected(cell: cell, indexPath: indexPath)
                }
            }
        }
        
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
        cell.isUserInteractionEnabled = true
        
        if !self.selectedDays.contains(indexPath.row) {
            self.selectedDays.append(indexPath.row)
        }
    }
    
    func setCellUnselected(cell: DayCell, indexPath: IndexPath) {
        cell.roundedView.tag = 0
        cell.roundedView.backgroundColor = UIColor.white
        cell.titleLabel.textColor = UIColor.mainBlue
        cell.titleLabel.font = UIFont(name: Constants.FontNames.GothamBook, size: 20.0)
        cell.isUserInteractionEnabled = true
        
        if let index = self.selectedDays.index(of: indexPath.row) {
            self.selectedDays.remove(at: index)
        }
    }
    
    func setCellNotAvailable(cell: DayCell, indexPath: IndexPath) {
        cell.roundedView.tag = 0
        cell.roundedView.backgroundColor = UIColor.mainWhiteTransparent40
        cell.titleLabel.textColor = UIColor.mainBlue
        cell.titleLabel.font = UIFont(name: Constants.FontNames.GothamBook, size: 20.0)
        cell.isUserInteractionEnabled = false
        
        for day in self.selectedDays {
            if !self.availableDays.contains(day) {
                if let deleteIndex = self.selectedDays.firstIndex(of: day) {
                    self.selectedDays.remove(at: deleteIndex)
                }
            }
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
