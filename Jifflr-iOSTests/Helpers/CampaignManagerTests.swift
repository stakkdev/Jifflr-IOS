//
//  CampaignManagerTests.swift
//  Jifflr-iOSTests
//
//  Created by James Shaw on 22/05/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import XCTest
import Parse
@testable import Jifflr_iOS

class CampaignManagerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testValidActivationBalance() {
        let budgetViewValue = 15.0
        let campaignBudget = 10.0
        
        let result = CampaignManager.shared.isValidBalance(budgetViewValue: budgetViewValue, campaignBudget: campaignBudget)
        XCTAssertTrue(result)
    }
    
    func testInvalidActivationBalance() {
        let budgetViewValue = 0.0
        let campaignBudget = 10.0
        
        let result = CampaignManager.shared.isValidBalance(budgetViewValue: budgetViewValue, campaignBudget: campaignBudget)
        XCTAssertFalse(result)
    }
    
    func testActivationPass() {
        let budgetViewValue = 15.0
        let campaignBudget = 5.0
        let userCampaignBalance = 12.0
        
        let result = CampaignManager.shared.canActivateCampaign(budgetViewValue: budgetViewValue, campaignBudget: campaignBudget, userCampaignBalance: userCampaignBalance)
        XCTAssertTrue(result)
    }
    
    func testActivationFail() {
        let budgetViewValue = 20.0
        let campaignBudget = 5.0
        let userCampaignBalance = 13.0
        
        let result = CampaignManager.shared.canActivateCampaign(budgetViewValue: budgetViewValue, campaignBudget: campaignBudget, userCampaignBalance: userCampaignBalance)
        XCTAssertFalse(result)
    }
    
    func testActivation() {
        let userDetails = UserDetails()
        userDetails.campaignBalance = 20.0
        
        let user = PFUser()
        user.details = userDetails
        
        let campaign = Campaign()
        campaign.budget = 0.0
        campaign.balance = 0.0
        
        CampaignManager.shared.activateCampaign(user: user, campaign: campaign, budget: 17.0)
        
        XCTAssertEqual(user.details.campaignBalance, 3.0)
        XCTAssertEqual(campaign.budget, 17.0)
        XCTAssertEqual(campaign.balance, 17.0)
    }
    
    func testUpdateBudget() {
        let userDetails = UserDetails()
        userDetails.campaignBalance = 20.0
        
        let user = PFUser()
        user.details = userDetails
        
        let campaign = Campaign()
        campaign.budget = 1500.0
        campaign.balance = 1300.0
        
        CampaignManager.shared.updateCampaignBudget(campaign: campaign, user: user, amount: 18.0)
        
        XCTAssertEqual(user.details.campaignBalance, 2.0)
        XCTAssertEqual(campaign.budget, 33.0)
        XCTAssertEqual(campaign.balance, 31.0)
    }
}
