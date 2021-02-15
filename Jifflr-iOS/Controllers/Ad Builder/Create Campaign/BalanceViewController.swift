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
    
    @IBOutlet weak var paypalEmailHeadingLabel: UILabel!
    @IBOutlet weak var paypalEmailTextField: JifflrTextField!
    @IBOutlet weak var currentBalanceHeadingLabelTop: NSLayoutConstraint!
    
    var isWithdrawal = false
    var myBalance: MyBalance = MyBalance() {
        didSet {
            updateUI()
        }
    }

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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateData()
    }
    
    func updateData() {
        if Reachability.isConnectedToNetwork() {
            CampaignManager.shared.fetchMyBalance { (myBalance, error) in
                guard let myBalance = myBalance, error == nil else {
                    self.displayError(error: error)
                    return
                }
                self.myBalance = myBalance
            }
        }
    }
    
    func setupUI() {
        self.setupLocalization()
        
        self.setBackgroundImage(image: UIImage(named: "MainBackground"))
        self.confirmButton.setBackgroundColor(color: UIColor.mainPink)
        
        self.currentBalanceTextField.textColor = UIColor.white
        self.currentBalanceTextField.backgroundColor = UIColor(white: 1.0, alpha: 0.2)
        self.currentBalanceTextField.isUserInteractionEnabled = false
        self.amountTextField.delegate = self
        self.paypalEmailTextField.delegate = self
        
        if self.isWithdrawal {
            self.currentBalanceHeadingLabelTop.constant = 150.0
            self.paypalEmailTextField.isHidden = false
            self.paypalEmailHeadingLabel.isHidden = false
        } else {
            self.currentBalanceHeadingLabelTop.constant = 10.0
            self.paypalEmailTextField.isHidden = true
            self.paypalEmailHeadingLabel.isHidden = true
        }
        
        guard let user = Session.shared.currentUser else { return }
        self.amountTextField.text = "\(Session.shared.currentCurrencySymbol)\(String(format: "%.2f", 10.00))"

        
        if let email = user.details.campaignPayPalEmail {
            self.paypalEmailTextField.text = email
        }
    }
    
    func updateUI() {
        let total: Double = myBalance.totalBalance
        self.currentBalanceTextField.text = "\(Session.shared.currentCurrencySymbol)\(String(format: "%.2f", total))"
        
    }
    
    func setupLocalization() {
        self.title = self.isWithdrawal ? "balanceWithdrawal.navigation.title".localized() : "balanceTopUp.navigation.title".localized()
        self.currentBalanceHeadingLabel.text = "balanceWithdrawal.currentBalance.heading".localized()
        self.amountHeadingLabel.text = self.isWithdrawal ? "balanceWithdrawal.withdrawalAmount.heading".localized() : "balanceTopUp.topUpAmount.heading".localized()
        self.amountTextField.placeholder = self.isWithdrawal ? "balanceWithdrawal.withdrawalAmount.placeholder".localized() : "balanceTopUp.topUpAmount.placeholder".localized()
        self.confirmButton.setTitle("balanceWithdrawal.confirmButton.title".localized(), for: .normal)
        self.paypalEmailHeadingLabel.text = "balanceWithdrawal.paypalEmail.heading".localized()
        self.paypalEmailTextField.placeholder = "balanceWithdrawal.paypalEmail.placeholder".localized()
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
        
        if let error = self.validateWithrawal()  {
            self.displayError(error: error)
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
    
    func validateWithrawal() -> ErrorMessage? {
        
        guard let paypalEmail = self.paypalEmailTextField.text, !paypalEmail.isEmpty, paypalEmail.isEmail() else {
            return ErrorMessage.withdrawalValidationFailed
        }
        
        guard myBalance.totalBalance >= self.getAmount() else {
            return ErrorMessage.withdrawalValidationFailed
        }
        
        guard myBalance.availableBalance >= self.getAmount() else {
            return ErrorMessage.withdrawalValidationAmount(myBalance.availableBalance, myBalance.credit)
        }
        
        return nil
    }
    
    func handleTopUp() {
        guard self.validateTopUp() else {
            self.displayError(error: ErrorMessage.minTopUpAmount)
            return
        }

        let addCardViewController = STPAddCardViewController()
        addCardViewController.delegate = self
        addCardViewController.title = "balanceTopUp.stride.title".localized()
        let navigationController = UINavigationController(rootViewController: addCardViewController)
        navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.navigationBar.isTranslucent = true
        let font = UIFont(name: Constants.FontNames.GothamBold, size: 18.0)!
        navigationController.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: font, NSAttributedStringKey.foregroundColor: UIColor.white]
        navigationController.navigationBar.tintColor = UIColor.white
        self.modalPresentationStyle = .fullScreen
        navigationController.modalPresentationStyle = .fullScreen
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
        return amount.rounded(toPlaces: 2)
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
            guard let currency = text.first else { return }
            guard let value = Double(text[1..<text.count]) else { return }
            
            let newString = String(format: "%@%.2f", "\(currency)", value)
            textField.text = newString
        } else {
            guard let user = Session.shared.currentUser else { return }
            
            if let paypalEmail = textField.text, !paypalEmail.isEmpty, paypalEmail.isEmail() {
                user.details.campaignPayPalEmail = paypalEmail
                user.saveAndPin { (error) in
                    guard let error = error else { return }
                    self.displayError(error: error)
                    textField.text = user.details.campaignPayPalEmail
                }
            } else if let paypalEmail = textField.text, !paypalEmail.isEmpty {
                self.displayError(error: ErrorMessage.withdrawalEmail)
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
        
        self.dismiss(animated: true) {
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
                        self.displayMessage(title: alert.title, message: alert.message, dismissText: nil, dismissAction: { (action) in
                            self.navigationController?.popViewController(animated: true)
                        })
                    })
                }
            }
        }
    }
}
