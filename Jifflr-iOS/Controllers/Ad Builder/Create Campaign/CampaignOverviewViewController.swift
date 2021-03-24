//
//  CampaignOverviewViewController.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 17/04/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit

class CampaignOverviewViewController: BaseViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var campaignNameHeadingLabel: UILabel!
    @IBOutlet weak var campaignNameLabel: UILabel!
    @IBOutlet weak var advertHeadingLabel: UILabel!
    @IBOutlet weak var advertLabel: UILabel!
    @IBOutlet weak var statusHeadingLabel: UILabel!
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet var statusImageViewWidth: NSLayoutConstraint!
    @IBOutlet weak var dateHeadingLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeHeadingLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var daysOfWeekHeadingLabel: UILabel!
    @IBOutlet weak var daysOfWeekLabel: UILabel!
    @IBOutlet weak var genderHeadingLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var locationHeadingLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var agesHeadingLabel: UILabel!
    @IBOutlet weak var agesLabel: UILabel!
    @IBOutlet weak var languageHeadingLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var estimatedAudienceHeadingLabel: UILabel!
    @IBOutlet weak var estimatedAudienceLabel: UILabel!
    @IBOutlet weak var estimatedCampaignCostHeadingLabel: UILabel!
    @IBOutlet weak var estimatedCampaignCostLabel: UILabel!
    @IBOutlet weak var costPerViewHeadingLabel: UILabel!
    @IBOutlet weak var costPerViewLabel: UILabel!
    @IBOutlet weak var budgetCoverageHeadingLabel: UILabel!
    @IBOutlet weak var budgetCoverageLabel: UILabel!
    @IBOutlet weak var budgetView: BudgetView!
    @IBOutlet weak var campaignNameView: UIView!
    @IBOutlet weak var advertView: UIView!
    @IBOutlet weak var scheduleView: UIView!
    @IBOutlet weak var demographicView: UIView!
    @IBOutlet weak var statsView: UIView!
    @IBOutlet weak var campaignNumberLabel: UILabel!
    @IBOutlet weak var adNumberLabel: UILabel!
    
    @IBOutlet weak var activatedView: UIView!
    @IBOutlet weak var activateButton: JifflrButton!
    @IBOutlet var budgetViewTop: NSLayoutConstraint!
    @IBOutlet weak var activeLabel: UILabel!
    @IBOutlet weak var activeSwitch: UISwitch!
    @IBOutlet weak var campaignResultsButton: JifflrButton!
    @IBOutlet weak var updateButton: JifflrButton!
    @IBOutlet weak var copyCampaignButton: JifflrButton!
    @IBOutlet weak var deleteCampaign: JifflrButton!
    @IBOutlet var activateButtonBottom: NSLayoutConstraint!
    @IBOutlet var activatedViewBottom: NSLayoutConstraint!
    
    var campaign: Campaign!
    var adSubmissionFee = 5
    var myBalance: MyBalance?

    class func instantiateFromStoryboard(campaign: Campaign) -> CampaignOverviewViewController {
        let storyboard = UIStoryboard(name: "CreateCampaign", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CampaignOverviewViewController") as! CampaignOverviewViewController
        vc.campaign = campaign
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        self.handleNonComplianceFeedback()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupData()
    }
    
    func setupUI() {
        self.budgetView.delegate = self
        self.setupLocalization()
        self.setupGestures()
        self.setupUIBasedOnStatus()
        
        self.setBackgroundImage(image: UIImage(named: "MainBackground"))
        self.activateButton.setBackgroundColor(color: UIColor.mainGreen)
        self.campaignResultsButton.setBackgroundColor(color: UIColor.mainPink)
        self.updateButton.setBackgroundColor(color: UIColor.mainGreen)
        self.copyCampaignButton.setBackgroundColor(color: UIColor.mainOrange)
        self.deleteCampaign.setBackgroundColor(color: UIColor.mainBlueTransparent80)
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.setHidesBackButton(false, animated: false)
        self.createBalanceButton()
    }
    
    func setupGestures() {
        let campaignNameTap = UITapGestureRecognizer(target: self, action: #selector(self.campaignNamedTapped(gesture:)))
        self.campaignNameView.addGestureRecognizer(campaignNameTap)
        
        let advertTap = UITapGestureRecognizer(target: self, action: #selector(self.advertTapped(gesture:)))
        self.advertView.addGestureRecognizer(advertTap)
        
        let scheduleTap = UITapGestureRecognizer(target: self, action: #selector(self.scheduleTapped(gesture:)))
        self.scheduleView.addGestureRecognizer(scheduleTap)
        
        let demographicTap = UITapGestureRecognizer(target: self, action: #selector(self.demographicTapped(gesture:)))
        self.demographicView.addGestureRecognizer(demographicTap)
        
        let statsTap = UITapGestureRecognizer(target: self, action: #selector(self.statsTapped(gesture:)))
        self.statsView.addGestureRecognizer(statsTap)
    }
    
    func createBalanceButton() {
        guard let userDetails = Session.shared.currentUser?.details else { return }
        
        let button = UIButton(type: .custom)
        button.titleLabel?.numberOfLines = 0
        let title = "campaignOverview.balanceButton.title".localizedFormat("\(Session.shared.currentCurrencySymbol)\(String(format: "%.2f", userDetails.campaignBalance))")
        button.setTitle(title, for: .normal)
        button.titleLabel?.textAlignment = .left
        button.titleLabel?.font = UIFont(name: Constants.FontNames.GothamBold, size: 14.0)
        button.setTitleColor(UIColor.white, for: .normal)
        button.sizeToFit()
        button.addTarget(self, action: #selector(self.balanceButtonPressed(sender:)), for: .touchUpInside)
        let barButtonItem = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = barButtonItem
    }
    
    func setupLocalization() {
        self.title = "campaignOverview.navigation.title".localized()
        self.campaignNameHeadingLabel.text = "campaignOverview.campaignName.heading".localized()
        self.advertHeadingLabel.text = "campaignOverview.advert.heading".localized()
        self.statusHeadingLabel.text = "campaignOverview.status.heading".localized()
        self.dateHeadingLabel.text = "campaignOverview.date.heading".localized()
        self.timeHeadingLabel.text = "campaignOverview.time.heading".localized()
        self.daysOfWeekHeadingLabel.text = "campaignOverview.daysOfWeek.heading".localized()
        self.genderHeadingLabel.text = "campaignOverview.gender.heading".localized()
        self.agesHeadingLabel.text = "campaignOverview.ages.heading".localized()
        self.locationHeadingLabel.text = "campaignOverview.location.heading".localized()
        self.languageHeadingLabel.text = "campaignOverview.language.heading".localized()
        self.estimatedAudienceHeadingLabel.text = "campaignOverview.estimatedAudience.heading".localized()
        self.costPerViewHeadingLabel.text = "campaignOverview.costPerView.heading".localized()
        self.estimatedCampaignCostHeadingLabel.text = "campaignOverview.estimatedCampaignCost.heading".localized()
        self.budgetCoverageHeadingLabel.text = "campaignOverview.budgetCoverage.heading".localized()
        self.activateButton.setTitle("campaignOverview.activateButton.title".localized(), for: .normal)
        self.campaignResultsButton.setTitle("campaignOverview.getCampaignResultsButton.title".localized(), for: .normal)
        self.updateButton.setTitle("campaignOverview.updateButton.title".localized(), for: .normal)
        self.copyCampaignButton.setTitle("campaignOverview.copyCampaignButton.title".localized(), for: .normal)
        self.deleteCampaign.setTitle("campaignOverview.deleteCampaignButton.title".localized(), for: .normal)
        self.activeLabel.text = "campaignOverview.activeLabel.text".localized()
    }
    
    func setupData() {
        guard let demographic = self.campaign.demographic else { return }
        self.campaignNameLabel.text = self.campaign.name
        self.advertLabel.text = self.campaign.advert.details?.name
        self.handleStatus(status: self.campaign.status)
        self.genderLabel.text = demographic.gender?.name ?? "createTarget.gender.all".localized()
        self.locationLabel.text = demographic.location.name
        self.languageLabel.text = demographic.language.name
        
        if let schedule = self.campaign.schedule {
            self.dateLabel.text = CampaignManager.shared.startEndDateString(schedule: schedule)
            self.timeLabel.text = CampaignManager.shared.startEndTimeString(schedule: schedule)
            self.daysOfWeekLabel.text = CampaignManager.shared.daysOfWeekString(schedule: schedule)
        }
        
        let minAge = demographic.minAge
        let maxAge = demographic.maxAge
        self.agesLabel.text = "\(minAge)-\(maxAge)"
        
        self.estimatedAudienceLabel.text = "\(demographic.estimatedAudience)"
        self.costPerViewLabel.text = "\(Session.shared.currentCurrencySymbol)\(self.formatCostPerView())"
        
        let campaignCost = Double(demographic.estimatedAudience) * self.campaign.costPerView
        self.estimatedCampaignCostLabel.text = "\(Session.shared.currentCurrencySymbol)\(String(format: "%.2f", campaignCost))"

        self.budgetView.value = self.campaign.balance == 0.0 ? self.budgetView.value : self.campaign.balance
        
        self.campaignNumberLabel.text = "C# \(self.campaign.number)"
        self.campaignNumberLabel.isHidden = self.campaign.number == 0
        self.adNumberLabel.text = "A# \(self.campaign.advert.details?.number ?? 0)"
        
        CampaignManager.shared.campaignInEdit = nil
        
        CampaignManager.shared.getAdSubmissionFee(demographic: demographic) { (adSubmissionFee) in
            self.adSubmissionFee = adSubmissionFee
            
            let val = self.campaign.objectId == nil ? self.campaign.balance - Double(self.adSubmissionFee) : self.campaign.balance
            
            guard val > 0 else {
                self.budgetCoverageLabel.text = "0%"
                return
            }
            
            guard demographic.estimatedAudience != 0 else {
                self.budgetCoverageLabel.text = "0%"
                return
            }
            let totalBalance = self.campaign.balance + (Double(self.campaign.adsViewedCount) * self.campaign.costPerView)
            let totalAudienceCost: Double =  Double(self.campaign.demographic?.estimatedAudience ?? 0) * self.campaign.costPerView
            let budgetCoverage = totalBalance / totalAudienceCost
            self.budgetCoverageLabel.text = "\(round(budgetCoverage * 100))%"
            
        }
        CampaignManager.shared.fetchMyBalance { (myBalance, error) in
            guard let myBalance = myBalance, error == nil else {
                self.displayError(error: error)
                return
            }
            self.myBalance = myBalance
            self.updateBalanceButton()
        }
    }
    
    func formatCostPerView() -> String {
        let costPerView = String(format: "%.10f", self.campaign.costPerView)
        let sections = costPerView.components(separatedBy: ".")
        guard sections.count == 2 else { return costPerView }
        
        var afterDecimalPoint = sections.last!
        for i in (0...afterDecimalPoint.count-1).reversed() {
            let firstIndex = afterDecimalPoint.startIndex
            let charIndex = afterDecimalPoint.index(firstIndex, offsetBy: i)
            let char = afterDecimalPoint[charIndex]
            if char == "0" {
                afterDecimalPoint.remove(at: charIndex)
            } else {
                break
            }
        }
        
        let formattedCostPerView = sections.first! + "." + afterDecimalPoint
        return formattedCostPerView
    }
    
    func updateBalanceButton() {
        guard let userDetails = Session.shared.currentUser?.details else { return }
        guard let barButtonItem = self.navigationItem.rightBarButtonItem else { return }
        guard let button = barButtonItem.customView as? UIButton else { return }
        let currentBalance: Double = myBalance?.totalBalance ?? 0
        let title = "campaignOverview.balanceButton.title".localizedFormat("\(Session.shared.currentCurrencySymbol)\(String(format: "%.2f", currentBalance))")
        button.setTitle(title, for: .normal)
        button.sizeToFit()
        let buttonTitle = userDetails.campaignBalance != 0.0 ? "campaignOverview.activateButton.title".localized() : "campaignOverview.activateAndPayButton.title".localized()
        self.activateButton.setTitle(buttonTitle, for: .normal)
    }
    
    func setupUIBasedOnStatus() {
        if let status = self.campaign.status {
            self.setUIActivated(status: status)
        } else {
            self.setUIUnactivated()
        }
    }
    
    func setUIActivated(status: String) {
        self.budgetViewTop.constant = 80.0
        self.activateButton.isHidden = true
        self.activateButton.isEnabled = false
        self.activeLabel.isHidden = false
        self.activeSwitch.isHidden = false
        self.activatedView.isHidden = false
        self.activatedView.isUserInteractionEnabled = true
        self.activateButtonBottom.isActive = false
        self.activatedViewBottom.isActive = true
        
        switch status {
        case CampaignStatusKey.availableActive, CampaignStatusKey.availableScheduled, CampaignStatusKey.pendingModeration:
            self.activeSwitch.isOn = true
        default:
            self.activeSwitch.isOn = false
        }
    }
    
    func setUIUnactivated() {
        self.budgetViewTop.constant = 18.0
        self.activateButton.isHidden = false
        self.activateButton.isEnabled = true
        self.activeLabel.isHidden = true
        self.activeSwitch.isHidden = true
        self.activatedView.isHidden = true
        self.activatedView.isUserInteractionEnabled = false
        self.activateButtonBottom.isActive = true
        self.activatedViewBottom.isActive = false
    }
    
    func handleStatus(status: String?) {
        guard let status = status else {
            self.drawCircle(color: UIColor.inactiveAdvertGrey)
            return
        }
        
        self.campaignResultsButton.isEnabled = true
        self.campaignResultsButton.setBackgroundColor(color: UIColor.mainPink)
        self.copyCampaignButton.isEnabled = true
        self.copyCampaignButton.setBackgroundColor(color: UIColor.mainOrange)

        switch status {
        case CampaignStatusKey.availableActive:
            self.drawCircle(color: UIColor.mainGreen)
            self.campaignResultsButton.isEnabled = false
            self.campaignResultsButton.setBackgroundColor(color: UIColor.mainPinkTransparent50)
            self.copyCampaignButton.isEnabled = false
            self.copyCampaignButton.setBackgroundColor(color: UIColor.mainOrangeTransparent50)
        case CampaignStatusKey.pendingModeration:
            self.setTimerImage(color: UIColor.mainGreen)
        case CampaignStatusKey.availableScheduled:
            self.setTimerImage(color: UIColor.mainGreen)
        case CampaignStatusKey.inactive:
            self.drawCircle(color: UIColor.inactiveAdvertGrey)
        case CampaignStatusKey.nonCompliant:
            self.drawCircle(color: UIColor.mainRed)
        case CampaignStatusKey.nonCompliantScheduled:
            self.setTimerImage(color: UIColor.mainRed)
        case CampaignStatusKey.prepareToDelete:
            self.setTimerImage(color: UIColor.mainRed)
        default:
            self.drawCircle(color: UIColor.mainRed)
        }
    }
    
    func drawCircle(color: UIColor) {
        self.statusImageView.backgroundColor = color
        self.statusImageView.layer.cornerRadius = 7.0
        self.statusImageView.layer.masksToBounds = true
        self.statusImageView.image = nil
        self.statusImageViewWidth.constant = 14.0
    }
    
    func setTimerImage(color: UIColor) {
        self.statusImageView.backgroundColor = UIColor.clear
        self.statusImageView.layer.cornerRadius = 0.0
        self.statusImageViewWidth.constant = 18.0
        
        let image = UIImage(named: "AdvertScheduledTimer")!.withRenderingMode(.alwaysTemplate)
        self.statusImageView.image = image
        self.statusImageView.tintColor = color
    }
    
    func handleNonComplianceFeedback() {
        ModerationManager.shared.shouldShowNonComplianceFeedback(campaign: self.campaign) { (yes) in
            if yes {
                let title = "nonCompliance.alert.title".localized()
                let message = "nonCompliance.alert.message".localized()
                let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                
                let dismissAction = UIAlertAction(title: "error.dismiss".localized(), style: .cancel, handler: nil)
                alertController.addAction(dismissAction)
                
                let viewAction = UIAlertAction(title: "nonCompliance.alert.viewAction".localized(), style: .default) { (action) in
                    let vc = NonComplianceViewController.instantiateFromStoryboard(campaign: self.campaign)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                alertController.addAction(viewAction)
                
                self.present(alertController, animated: true, completion: nil)
            } else {
                self.handleAdFlaggedFeedback()
            }
        }
    }
    
    func handleAdFlaggedFeedback() {
        ModerationManager.shared.shouldShowAdFlaggedFeedback(campaign: self.campaign) { (yes) in
            if yes {
                let title = "feedback.alert.title".localized()
                let message = "feedback.alert.message".localized()
                let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                
                let dismissAction = UIAlertAction(title: "error.dismiss".localized(), style: .cancel, handler: nil)
                alertController.addAction(dismissAction)
                
                let viewAction = UIAlertAction(title: "nonCompliance.alert.viewAction".localized(), style: .default) { (action) in
                    let vc = NonComplianceViewController.instantiateFromStoryboard(campaign: self.campaign, isNonCompliant: false)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                alertController.addAction(viewAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
}

extension CampaignOverviewViewController: BudgetViewDelegate {
    func valueChanged(value: Double) {
        guard let demographic = self.campaign.demographic else { return }
        let val = self.campaign.objectId == nil ? value - Double(self.adSubmissionFee) : value
        
        guard val > 0 else {
            self.budgetCoverageLabel.text = "0%"
            return
        }
        
        guard demographic.estimatedAudience != 0 else {
            self.budgetCoverageLabel.text = "0%"
            return
        }
        
        let totalBalance = value + (Double(self.campaign.adsViewedCount) * self.campaign.costPerView)
        let totalAudienceCost: Double =  Double(self.campaign.demographic?.estimatedAudience ?? 0) * self.campaign.costPerView
        let budgetCoverage = totalBalance / totalAudienceCost
        self.budgetCoverageLabel.text = "\(round(budgetCoverage * 100))%"
    }
}
