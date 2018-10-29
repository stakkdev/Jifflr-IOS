//
//  BalanceViewController.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 20/04/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit
import Stripe

class BalanceViewController: BaseViewController {
    
    @IBOutlet weak var currentBalanceHeadingLabel: UILabel!
    @IBOutlet weak var currentBalanceTextField: JifflrTextField!
    @IBOutlet weak var amountHeadingLabel: UILabel!
    @IBOutlet weak var amountTextField: JifflrTextField!
    @IBOutlet weak var confirmButton: JifflrButton!
    
    var isWithdrawal = false

    class func instantiateFromStoryboard(isWithdrawal: Bool) -> BalanceViewController {
        let storyboard = UIStoryboard(name: "CreateCampaign", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "BalanceViewController") as! BalanceViewController
        vc.isWithdrawal = isWithdrawal
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }
    
    func setupUI() {
        self.setupLocalization()
        
        self.setBackgroundImage(image: UIImage(named: "MainBackground"))
        self.confirmButton.setBackgroundColor(color: UIColor.mainPink)
        
        self.currentBalanceTextField.textColor = UIColor.white
        self.currentBalanceTextField.backgroundColor = UIColor(white: 1.0, alpha: 0.2)
        self.currentBalanceTextField.isUserInteractionEnabled = false
        self.amountTextField.delegate = self
        
        guard let user = Session.shared.currentUser else { return }
        self.amountTextField.text = "\(Session.shared.currentCurrencySymbol)\(String(format: "%.2f", 10.00))"
        self.currentBalanceTextField.text = "\(Session.shared.currentCurrencySymbol)\(String(format: "%.2f", user.details.campaignBalance))"
    }
    
    func setupLocalization() {
        self.title = self.isWithdrawal ? "balanceWithdrawal.navigation.title".localized() : "balanceTopUp.navigation.title".localized()
        self.currentBalanceHeadingLabel.text = "balanceWithdrawal.currentBalance.heading".localized()
        self.amountHeadingLabel.text = self.isWithdrawal ? "balanceWithdrawal.withdrawalAmount.heading".localized() : "balanceTopUp.topUpAmount.heading".localized()
        self.amountTextField.placeholder = self.isWithdrawal ? "balanceWithdrawal.withdrawalAmount.placeholder".localized() : "balanceTopUp.topUpAmount.placeholder".localized()
        self.confirmButton.setTitle("balanceWithdrawal.confirmButton.title".localized(), for: .normal)
    }
    
    @IBAction func confirmButtonPressed(sender: JifflrButton) {
        if self.isWithdrawal {
            self.handleWithdrawal()
        } else {
            self.handleTopUp()
        }
    }
    
    func handleWithdrawal() {
        guard let user = Session.shared.currentUser else { return }
        
        guard self.validateWithdrawal() else {
            self.displayError(error: ErrorMessage.withdrawalValidationFailed)
            return
        }
        
        self.confirmButton.animate()
        CampaignManager.shared.withdraw(amount: self.getAmount()) { (error) in
            guard error == nil else {
                self.confirmButton.stopAnimating()
                self.displayError(error: error!)
                return
            }
            
            UserManager.shared.syncUser(completion: { (error) in
                self.confirmButton.stopAnimating()
                guard error == nil else {
                    self.displayError(error: error!)
                    return
                }
                
                self.currentBalanceTextField.text = "\(Session.shared.currentCurrencySymbol)\(String(format: "%.2f", user.details.campaignBalance))"
                
                let title = AlertMessage.withdrawalSuccess.title
                let message = AlertMessage.withdrawalSuccess.message
                self.displayMessage(title: title, message: message, dismissText: nil, dismissAction: nil)
            })
        }
    }
    
    func validateWithdrawal() -> Bool {
        guard let user = Session.shared.currentUser else { return false }
        guard user.details.campaignBalance >= self.getAmount() else { return false }
        
        return true
    }
    
    func handleTopUp() {
        guard self.validateTopUp() else {
            self.displayError(error: ErrorMessage.minTopUpAmount)
            return
        }

        let addCardViewController = STPAddCardViewController()
        addCardViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: addCardViewController)
        self.present(navigationController, animated: true)
    }
    
    func validateTopUp() -> Bool {
        let topUpAmount = self.getAmount()
        guard topUpAmount >= 10.0 else { return false }
        
        return true
    }
    
    func getAmount() -> Double {
        guard let text = self.amountTextField.text else { return 0.0 }
        var amountString = text
        amountString.remove(at: amountString.startIndex)
        
        guard let amount = Double(amountString) else { return 0.0 }
        return amount
    }
}

extension BalanceViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard textField == self.amountTextField else { return true }
        
        if range.location == 0 {
            return false
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.amountTextField {
            guard let text = textField.text else { return }
            if text.count == 1 {
                var newText = text
                newText += "1.00"
                textField.text = newText
            }
        } else {
            guard let paypalEmail = textField.text, !paypalEmail.isEmpty, paypalEmail.isEmail() else { return }
            guard let user = Session.shared.currentUser else { return }
            user.details.campaignPayPalEmail = paypalEmail
            user.saveAndPin { (error) in
                guard let error = error else { return }
                self.displayError(error: error)
                textField.text = user.details.campaignPayPalEmail
            }
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
}

extension BalanceViewController: STPAddCardViewControllerDelegate {
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreateToken token: STPToken, completion: @escaping STPErrorBlock) {
        
        guard let user = Session.shared.currentUser else { return }
        
        let topUpAmount = self.getAmount()
        self.confirmButton.animate()
        CampaignManager.shared.topUp(token: token.tokenId, amount: topUpAmount) { (error) in
            DispatchQueue.main.async {
                guard error == nil else {
                    self.displayError(error: error)
                    self.confirmButton.stopAnimating()
                    return
                }
                
                UserManager.shared.syncUser(completion: { (error) in
                    self.confirmButton.stopAnimating()
                    
                    guard error == nil else {
                        self.displayError(error: error)
                        return
                    }
                    
                    self.currentBalanceTextField.text = "\(Session.shared.currentCurrencySymbol)\(String(format: "%.2f", user.details.campaignBalance))"
                    
                    let alert = AlertMessage.paypalTopUpSuccess
                    self.displayMessage(title: alert.title, message: alert.message, dismissText: nil, dismissAction: nil)
                })
            }
        }
    }
}
