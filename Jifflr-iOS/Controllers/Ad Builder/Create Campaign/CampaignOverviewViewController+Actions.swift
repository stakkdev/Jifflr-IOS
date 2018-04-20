//
//  CampaignOverviewViewController+Actions.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 20/04/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import Foundation

extension CampaignOverviewViewController {
    @IBAction func getCampaignResultsButtonPressed(sender: JifflrButton) {
        
    }
    
    @IBAction func updateButtonPressed(sender: JifflrButton) {
        
    }
    
    @IBAction func copyCampaignPressed(sender: JifflrButton) {
        
    }
    
    @IBAction func deleteCampaign(sender: JifflrButton) {
        
    }
    
    @IBAction func activateSwitchChanged(sender: UISwitch) {
        
    }
    
    @objc func balanceButtonPressed(sender: UIButton) {
        let title = "campaignOverview.balanceActionSheet.title".localized()
        let actionSheet = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "campaignOverview.cancelButton.title".localized(), style: .cancel) { (action) in }
        actionSheet.addAction(cancelAction)
        
        let topUpAction = UIAlertAction(title: "campaignOverview.balanceTopUpButton.title".localized(), style: .default) { (action) in
            let vc = BalanceViewController.instantiateFromStoryboard(isWithdrawal: false)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        actionSheet.addAction(topUpAction)
        
        let withdrawAction = UIAlertAction(title: "campaignOverview.withdrawalButton.title".localized(), style: .default) { (action) in
            let vc = BalanceViewController.instantiateFromStoryboard(isWithdrawal: true)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        actionSheet.addAction(withdrawAction)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @objc func campaignNamedTapped(gesture: UITapGestureRecognizer) {
        let vc = CreateScheduleViewController.instantiateFromStoryboard(advert: self.campaign.advert, campaign: self.campaign, isEdit: true)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func advertTapped(gesture: UITapGestureRecognizer) {
        let vc = CreateScheduleViewController.instantiateFromStoryboard(advert: self.campaign.advert, campaign: self.campaign, isEdit: true)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func scheduleTapped(gesture: UITapGestureRecognizer) {
        let vc = CreateScheduleViewController.instantiateFromStoryboard(advert: self.campaign.advert, campaign: self.campaign, isEdit: true)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func demographicTapped(gesture: UITapGestureRecognizer) {
        let vc = CreateTargetViewController.instantiateFromStoryboard(campaign: self.campaign, isEdit: true)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func statsTapped(gesture: UITapGestureRecognizer) {
        let vc = CreateTargetViewController.instantiateFromStoryboard(campaign: self.campaign, isEdit: true)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func activateButtonPressed(sender: JifflrButton) {
        
    }
}
