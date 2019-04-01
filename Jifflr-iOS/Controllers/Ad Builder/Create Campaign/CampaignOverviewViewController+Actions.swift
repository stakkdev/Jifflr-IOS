//
//  CampaignOverviewViewController+Actions.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 20/04/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import Foundation
import MBProgressHUD

extension CampaignOverviewViewController {
    @IBAction func getCampaignResultsButtonPressed(sender: JifflrButton) {
        self.campaignResultsButton.animate()
        self.disableButtons()
        CampaignManager.shared.getCampaignResults(campaign: self.campaign) { (error) in
            self.campaignResultsButton.stopAnimating()
            self.enableButtons()
            
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
        guard self.budgetView.value >= self.campaign.balance else {
            self.displayError(error: ErrorMessage.decreaseBudget)
            return
        }
        
        let difference = self.budgetView.value - self.campaign.balance
        guard user.details.campaignBalance > difference else {
            self.handleInsufficientBalance(isActivation: false)
            return
        }
        
        CampaignManager.shared.updateCampaignBudget(campaign: self.campaign, user: user, amount: difference)
        
        self.updateButton.animate()
        self.disableButtons()
        self.campaign.saveInBackgroundAndPin { (error) in
            user.saveAndPin(completion: { (error) in
                self.updateButton.stopAnimating()
                self.enableButtons()
                
                guard error == nil else {
                    self.displayError(error: ErrorMessage.increaseBudgetFailedFromServer)
                    return
                }
                
                self.campaign.fetchInBackground(block: { (campaign, error) in
                    guard let campaign = campaign as? Campaign, error == nil else {
                        self.activateButton.stopAnimating()
                        self.displayError(error: ErrorMessage.increaseBudgetFailedFromServer)
                        return
                    }
                    
                    self.campaign = campaign
                    campaign.pinInBackground(withName: CampaignManager.shared.pinName)
                    
                    self.updateBalanceButton()
                    
                    let alert = difference > 0 ? AlertMessage.increaseBudgetSuccess : AlertMessage.campaignUpdated
                    self.displayMessage(title: alert.title, message: alert.message, dismissText: nil, dismissAction: nil)
                })
            })
        }
    }
    
    func handleInsufficientBalance(isActivation: Bool) {
        let error = isActivation ? ErrorMessage.activationFailedInsufficientBalance : ErrorMessage.increaseBudgetFailed
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
        
        CampaignManager.shared.copy(campaign: self.campaign) { (campaign) in
            self.copyCampaignButton.stopAnimating()
            
            guard let campaign = campaign else {
                self.displayError(error: .unknown)
                return
            }
            
            self.campaign = campaign
            self.setupData()
            self.setupUIBasedOnStatus()
            let alert = AlertMessage.campaignCopied
            self.displayMessage(title: alert.title, message: alert.message, dismissText: nil) { (action) in
                self.scrollView.setContentOffset(.zero, animated: true)
            }
        }
    }
    
    @IBAction func deleteCampaign(sender: JifflrButton) {
        guard self.campaign.status != CampaignStatusKey.prepareToDelete else {
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
        self.disableButtons()
        
        self.campaign.status = CampaignStatusKey.prepareToDelete
        self.campaign.saveInBackgroundAndPin(completion: { (error) in
            self.deleteCampaign.stopAnimating()
            self.enableButtons()
            
            guard error == nil else {
                self.displayError(error: ErrorMessage.noInternetConnection)
                return
            }
            
            self.handleStatus(status: self.campaign.status)
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    @IBAction func activateSwitchChanged(sender: UISwitch) {
        let key = self.campaign.status
        guard key != CampaignStatusKey.nonCompliant && key != CampaignStatusKey.nonCompliantScheduled && key != CampaignStatusKey.prepareToDelete else {
            sender.isOn = false
            self.displayError(error: ErrorMessage.nonCompliantActivate)
            return
        }
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        CampaignManager.shared.handleEnableCampaign(on: sender.isOn, campaign: self.campaign) { (campaign, error) in
            MBProgressHUD.hide(for: self.view, animated: true)
            guard error == nil else {
                sender.isOn = !sender.isOn
                self.displayError(error: error!)
                return
            }
            
            self.campaign = campaign
            self.handleStatus(status: self.campaign.status)
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
        self.goToAdvert()
    }
    
    @objc func advertTapped(gesture: UITapGestureRecognizer) {
        self.goToAdvert()
    }
    
    func goToAdvert() {
        let amount = "\(Session.shared.currentCurrencySymbol)\(self.adSubmissionFee)"
        
        guard self.budgetView.value >= Double(self.adSubmissionFee) else {
            self.displayError(error: ErrorMessage.updateCampaignContent(amount))
            return
        }
        
        let alertController = UIAlertController(title: "alert.adSubmissionFee.title".localized(), message: "alert.contentChangedSubmissionFee.message".localizedFormat(amount), preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "alert.adSubmissionFee.cancel".localized(), style: .cancel, handler: { (action) in
            self.activateButton.stopAnimating()
            return
        })
        alertController.addAction(cancelAction)
        
        let agreeAction = UIAlertAction(title: "alert.adSubmissionFee.agree".localized(), style: .default, handler: { (action) in
            CampaignManager.shared.campaignInEdit = self.campaign
            let vc = AddContentViewController.instantiateFromStoryboard(advert: self.campaign.advert)
            self.navigationController?.pushViewController(vc, animated: true)
        })
        
        alertController.addAction(agreeAction)
        self.present(alertController, animated: true, completion: nil)
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
        guard let user = Session.shared.currentUser else { return }
        
        guard Reachability.isConnectedToNetwork() else {
            self.displayError(error: ErrorMessage.NoInternetConnectionRegistration)
            return
        }
        
        self.campaign.budget = 0.0
        
        self.activateButton.animate()
        
        CampaignManager.shared.isValidBalance(balance: self.budgetView.value, campaign: self.campaign) { (valid, error, fee) in
            guard let fee = fee, valid == true, error == nil else {
                self.activateButton.stopAnimating()
                self.displayError(error: error)
                return
            }
            
            guard user.details.campaignBalance != 0.0 else {
                self.activateButton.stopAnimating()
                let vc = BalanceViewController.instantiateFromStoryboard(isWithdrawal: false)
                self.navigationController?.pushViewController(vc, animated: true)
                return
            }
            
            guard CampaignManager.shared.canActivateCampaign(budgetViewValue: self.budgetView.value, campaignBudget: self.campaign.budget, userCampaignBalance: user.details.campaignBalance) else {
                self.activateButton.stopAnimating()
                self.handleInsufficientBalance(isActivation: true)
                return
            }
            
            let amount = "\(Session.shared.currentCurrencySymbol)\(fee)"
            let alertController = UIAlertController(title: "alert.adSubmissionFee.title".localized(), message: "alert.adSubmissionFee.message".localizedFormat(amount), preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "alert.adSubmissionFee.cancel".localized(), style: .cancel, handler: { (action) in
                self.activateButton.stopAnimating()
                return
            })
            alertController.addAction(cancelAction)
            
            let agreeAction = UIAlertAction(title: "alert.adSubmissionFee.agree".localized(), style: .default, handler: { (action) in
                let budget = self.budgetView.value - self.campaign.budget
                CampaignManager.shared.activateCampaign(user: user, campaign: self.campaign, budget: budget)
                
                self.activateButton.animate()
                self.campaign.saveInBackgroundAndPin { (error) in
                    guard error == nil else {
                        self.activateButton.stopAnimating()
                        self.displayError(error: ErrorMessage.campaignActivationFailed)
                        return
                    }
                    
                    self.campaign.fetchInBackground(block: { (campaign, error) in
                        guard let campaign = campaign as? Campaign, error == nil else {
                            self.activateButton.stopAnimating()
                            self.displayError(error: ErrorMessage.campaignActivationFailed)
                            return
                        }
                        
                        self.campaign = campaign
                        
                        user.saveAndPin(completion: { (error) in
                            self.activateButton.stopAnimating()
                            guard error == nil else {
                                self.displayError(error: ErrorMessage.campaignActivationFailed)
                                return
                            }
                            
                            self.setupData()
                            self.updateBalanceButton()
                            self.handleStatus(status: self.campaign.status)
                            self.setupUIBasedOnStatus()
                            self.updateNavigationStackAfterActivation()
                        })
                        
                        campaign.pinInBackground(withName: CampaignManager.shared.pinName)
                    })
                }
            })
            
            alertController.addAction(agreeAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func updateNavigationStackAfterActivation() {
        guard let viewControllers = self.navigationController?.viewControllers else { return }
        guard let dashboardViewController = viewControllers.first as? DashboardViewController else { return }
        
        var vc: UIViewController!
        if let noAds = viewControllers[1] as? NoAdsViewController {
            vc = noAds
        } else if let adBuilder = viewControllers[1] as? AdBuilderOverviewViewController {
            vc = adBuilder
        } else if let adBuilder = viewControllers[1] as? AdBuilderLandingViewController {
            vc = adBuilder
        } else {
            return
        }

        let newViewControllers = [dashboardViewController, vc!]
        self.navigationController?.setViewControllers(newViewControllers, animated: true)
    }
    
    func enableButtons() {
        self.campaignResultsButton.isEnabled = true
        self.updateButton.isEnabled = true
        self.copyCampaignButton.isEnabled = true
        self.deleteCampaign.isEnabled = true
    }
    
    func disableButtons() {
        self.campaignResultsButton.isEnabled = false
        self.updateButton.isEnabled = false
        self.copyCampaignButton.isEnabled = false
        self.deleteCampaign.isEnabled = false
    }
}
