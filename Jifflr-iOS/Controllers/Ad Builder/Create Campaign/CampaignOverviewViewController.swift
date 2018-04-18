//
//  CampaignOverviewViewController.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 17/04/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit

class CampaignOverviewViewController: BaseViewController {
    
    @IBOutlet weak var campaignNameHeadingLabel: UILabel!
    @IBOutlet weak var campaignNameLabel: UILabel!
    @IBOutlet weak var advertHeadingLabel: UILabel!
    @IBOutlet weak var advertLabel: UILabel!
    @IBOutlet weak var statusHeadingLabel: UILabel!
    @IBOutlet weak var statusView: UIView!
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
        
        self.setBackgroundImage(image: UIImage(named: "MainBackground"))
        
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
    }
    
    @objc func balanceButtonPressed(sender: UIButton) {
        
    }
}
