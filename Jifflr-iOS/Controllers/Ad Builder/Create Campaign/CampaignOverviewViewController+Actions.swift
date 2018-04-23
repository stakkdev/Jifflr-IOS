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
        self.campaignResultsButton.animate()
        CampaignManager.shared.getCampaignResults(campaign: self.campaign) { (error) in
            self.campaignResultsButton.stopAnimating()
            
            guard error == nil else {
                self.displayError(error: error)
                return
            }
            
            let alert = AlertMessage.campaignResultsSuccess
            self.displayMessage(title: alert.title, message: alert.message, dismissText: nil, dismissAction: nil)
        }
    }
    
    @IBAction func updateButtonPressed(sender: JifflrButton) {
        guard let user = Session.shared.currentUser else { return }
        guard self.budgetView.value > self.campaign.budget else { return }
        
        let difference = self.budgetView.value - self.campaign.budget
        guard user.details.campaignBalance > difference else {
            self.handleInsufficientBalance()
            return
        }
        
        self.updateButton.animate()
        CampaignManager.shared.updateCampaignBudget(campaign: self.campaign, amount: difference) { (error) in
            self.updateButton.stopAnimating()
            
            guard error == nil else {
                self.displayError(error: error)
                return
            }
            
            let alert = AlertMessage.increaseBudgetSuccess
            self.displayMessage(title: alert.title, message: alert.message, dismissText: nil, dismissAction: nil)
        }
    }
    
    func handleInsufficientBalance() {
        let error = ErrorMessage.increaseBudgetFailed
        let alertController = UIAlertController(title: error.failureTitle, message: error.failureDescription, preferredStyle: .alert)
        
        let noAction = UIAlertAction(title: "error.increaseBudgetFailed.noButton".localized(), style: .cancel) { (action) in }
        alertController.addAction(noAction)
        
        let yesAction = UIAlertAction(title: "error.increaseBudgetFailed.yesButton".localized(), style: .default) { (action) in
            let vc = BalanceViewController.instantiateFromStoryboard(isWithdrawal: false)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        alertController.addAction(yesAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func copyCampaignPressed(sender: JifflrButton) {
        self.copyCampaignButton.animate()
        CampaignManager.shared.copy(campaign: self.campaign) { (error) in
            self.copyCampaignButton.stopAnimating()
            guard error == nil else {
                self.displayError(error: error)
                return
            }
            
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func deleteCampaign(sender: JifflrButton) {
        guard self.campaign.status?.key != CampaignStatusKey.prepareToDelete else {
            let alert = AlertMessage.scheduledDeleteCampaign
            self.displayMessage(title: alert.title, message: alert.message, dismissText: nil, dismissAction: nil)
            return
        }
        
        let title = "alert.deleteCampaign.title".localized()
        let message = "alert.deleteCampaign.message".localized()
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        let cancelTitle = "alert.notifications.cancelButton".localized()
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { (action) in }
        alertController.addAction(cancelAction)
        
        let deleteAction = UIAlertAction(title: title, style: .destructive) { (action) in
            self.campaignDelete()
        }
        alertController.addAction(deleteAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func campaignDelete() {
        self.deleteCampaign.animate()
        CampaignManager.shared.fetchStatus(key: CampaignStatusKey.prepareToDelete) { (status) in
            guard let status = status else {
                self.deleteCampaign.stopAnimating()
                self.displayError(error: ErrorMessage.noInternetConnection)
                return
            }
            
            self.campaign.status = status
            self.campaign.saveInBackgroundAndPin(completion: { (error) in
                guard error == nil else {
                    self.displayError(error: ErrorMessage.noInternetConnection)
                    return
                }
                
                self.deleteCampaign.stopAnimating()
                self.handleStatus(status: status)
                self.navigationController?.popViewController(animated: true)
            })
        }
    }
    
    @IBAction func activateSwitchChanged(sender: UISwitch) {
        let key = self.campaign.status?.key
        guard key != CampaignStatusKey.nonCompliant && key != CampaignStatusKey.nonCompliantScheduled && key != CampaignStatusKey.prepareToDelete else {
            sender.isOn = false
            self.displayError(error: ErrorMessage.nonCompliantActivate)
            return
        }
        
        var statusKey = CampaignStatusKey.inactive
        
        if sender.isOn {
            if CampaignManager.shared.shouldCampaignBeActiveAvailable(campaign: self.campaign) {
                statusKey = CampaignStatusKey.availableActive
            } else {
                statusKey = CampaignStatusKey.availableScheduled
            }
        }
        
        CampaignManager.shared.fetchStatus(key: statusKey) { (status) in
            guard let status = status else {
                sender.isOn = !sender.isOn
                self.displayError(error: ErrorMessage.noInternetConnection)
                return
            }
            
            self.campaign.status = status
            self.campaign.saveInBackgroundAndPin(completion: { (error) in
                guard error == nil else {
                    sender.isOn = !sender.isOn
                    self.displayError(error: ErrorMessage.noInternetConnection)
                    return
                }
                
                self.handleStatus(status: status)
            })
        }
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
