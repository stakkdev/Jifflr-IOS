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
    @IBOutlet weak var statusImageViewWidth: NSLayoutConstraint!
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
    @IBOutlet weak var costPerReviewHeadingLabel: UILabel!
    @IBOutlet weak var costPerReviewLabel: UILabel!
    @IBOutlet weak var budgetCoverageHeadingLabel: UILabel!
    @IBOutlet weak var budgetCoverageLabel: UILabel!
    @IBOutlet weak var budgetView: BudgetView!
    
    @IBOutlet weak var activateButton: JifflrButton!
    
    var campaign: Campaign!

    class func instantiateFromStoryboard(campaign: Campaign) -> CampaignOverviewViewController {
        let storyboard = UIStoryboard(name: "CreateCampaign", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CampaignOverviewViewController") as! CampaignOverviewViewController
        vc.campaign = campaign
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }
    
    func setupUI() {
        self.setupLocalization()
        self.setupData()
        
        self.setBackgroundImage(image: UIImage(named: "MainBackground"))
        self.activateButton.setBackgroundColor(color: UIColor.mainGreen)
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.setHidesBackButton(false, animated: false)
        self.createBalanceButton()
    }
    
    func createBalanceButton() {
        let button = UIButton(type: .custom)
        button.titleLabel?.numberOfLines = 0
        let title = "campaignOverview.balanceButton.title".localizedFormat("£0.00")
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
        self.costPerReviewHeadingLabel.text = "campaignOverview.costPerReview.heading".localized()
        self.estimatedCampaignCostHeadingLabel.text = "campaignOverview.estimatedCampaignCost.heading".localized()
        self.budgetCoverageHeadingLabel.text = "campaignOverview.budgetCoverage.heading".localized()
    }
    
    func setupData() {
        self.campaignNameLabel.text = self.campaign.name
        self.advertLabel.text = self.campaign.advert.details?.name
        self.handleStatus(status: self.campaign.advert.status)
        self.genderLabel.text = self.campaign.demographic.gender?.name ?? "createTarget.gender.all".localized()
        self.locationLabel.text = self.campaign.demographic.location.name
        self.dateLabel.text = CampaignManager.shared.startEndDateString(schedule: self.campaign.schedule)
        self.timeLabel.text = CampaignManager.shared.startEndTimeString(schedule: self.campaign.schedule)
        self.daysOfWeekLabel.text = CampaignManager.shared.daysOfWeekString(schedule: self.campaign.schedule)
        
        let minAge = self.campaign.demographic.minAge
        let maxAge = self.campaign.demographic.maxAge
        self.agesLabel.text = "\(minAge)-\(maxAge)"
        
        self.estimatedAudienceLabel.text = "\(self.campaign.demographic.estimatedAudience)"
        self.costPerReviewLabel.text = "£\(self.campaign.costPerReview)"
        
        let campaignCost = Double(self.campaign.demographic.estimatedAudience) * self.campaign.costPerReview
        self.estimatedCampaignCostLabel.text = "£\(String(format: "%.2f", campaignCost))"
        
        var budgetCoverage = Int(campaignCost / self.budgetView.value)
        if campaignCost < self.budgetView.value {
            budgetCoverage *= 100
        }
        self.budgetCoverageLabel.text = "\(budgetCoverage)%"
    }
    
    @objc func balanceButtonPressed(sender: UIButton) {
        
    }
    
    @IBAction func activateButtonPressed(sender: JifflrButton) {
        
    }
    
    func handleStatus(status: AdvertStatus?) {
        guard let status = status else {
            self.drawCircle(color: UIColor.inactiveAdvertGrey)
            return
        }
        
        switch status.key {
        case AdvertStatusKey.availableActive:
            self.drawCircle(color: UIColor.mainGreen)
        case AdvertStatusKey.availableScheduled:
            self.setTimerImage(color: UIColor.mainGreen)
        case AdvertStatusKey.inactive:
            self.drawCircle(color: UIColor.inactiveAdvertGrey)
        case AdvertStatusKey.nonCompliant:
            self.drawCircle(color: UIColor.mainRed)
        case AdvertStatusKey.nonCompliantScheduled:
            self.setTimerImage(color: UIColor.mainRed)
        default:
            return
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
}
