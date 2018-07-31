//
//  CashoutViewController.swift
//  Ad-M8-iOS
//
//  Created by James Shaw on 13/10/2017.
//  Copyright © 2017 The Distance. All rights reserved.
//

import UIKit

class MyMoneyViewController: BaseViewController {

    @IBOutlet weak var segmentedControl: JifflrSegmentedControl!
    @IBOutlet weak var chart: JifflrTeamChart!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeaderView: UIView!

    var myMoney: MyMoney? {
        didSet {
            self.tableView.reloadData()

            guard let graphData = self.myMoney?.graph, graphData.count > 0 else {
                self.chart.showNoDataLabel()
                return
            }
            self.chart.setData(data: graphData, color: UIColor.mainGreen, fill: true, targetData: nil, targetColor: nil)
        }
    }

    var password: String?
    var paypalEmail: String?

    class func instantiateFromStoryboard() -> MyMoneyViewController {
        let storyboard = UIStoryboard(name: "MyMoney", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "MyMoneyViewController") as! MyMoneyViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.updateData()
    }

    func setupUI() {
        self.setupLocalization()

        self.setBackgroundImage(image: UIImage(named: "MainBackground"))
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.setHidesBackButton(false, animated: false)

        self.segmentedControl.highlightedColor = UIColor.mainGreen
        self.segmentedControl.delegate = self
        self.tableView.estimatedRowHeight = 70.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.chart.startSpinner()
    }

    func setupLocalization() {
        self.title = "myMoney.navigation.title".localized()
        self.segmentedControl.setButton1Title(text: "myMoney.segmentedControlButton1.title".localized())
        self.segmentedControl.setButton2Title(text: "myMoney.segmentedControlButton2.title".localized())
    }

    func updateData() {
        self.updateLocalData()
        
        if Reachability.isConnectedToNetwork() {
            MyMoneyManager.shared.fetch { (myMoney, error) in
                guard let myMoney = myMoney, error == nil else {
                    self.displayError(error: error)
                    self.updateLocalData()
                    return
                }

                self.myMoney = myMoney
            }
        }
    }

    func updateLocalData() {
        MyMoneyManager.shared.fetchLocal { (myMoney, error) in
            guard let myMoney = myMoney, error == nil else {
                self.chart.showNoDataLabel()
                return
            }

            self.myMoney = myMoney
        }
    }
}

extension MyMoneyViewController: JifflrSegmentedControlDelegate {
    func valueChanged() {
        if self.segmentedControl.selectedSegmentIndex == 0 {
            self.tableView.contentOffset.y = 0.0
            self.tableViewHeaderView.frame.size.height = 240.0
        } else {
            self.tableView.contentOffset.y = 180.0
            self.tableViewHeaderView.frame.size.height = 260.0
        }

        self.tableView.reloadData()
    }
}

extension MyMoneyViewController: CashoutCellDelegate {
    func cashoutCellPressed(cell: CashoutCell) {
        guard let currentUser = Session.shared.currentUser else { return }
        guard let paypalEmail = self.paypalEmail, !paypalEmail.isEmpty else {
            cell.stopAnimating()
            self.displayError(error: ErrorMessage.invalidPayPalEmail)
            return
        }

        currentUser.details.paypalEmail = paypalEmail
        currentUser.details.saveInBackground { (success, error) in
            guard success == true, error == nil else {
                cell.stopAnimating()
                self.displayError(error: ErrorMessage.paypalEmailSaveFailed)
                return
            }

            guard let password = self.password else {
                cell.stopAnimating()
                self.displayError(error: ErrorMessage.invalidCashoutPassword)
                return
            }

            CashoutManager.shared.cashout(password: password) { (error) in
                cell.stopAnimating()
                guard error == nil else {
                    self.displayError(error: error)
                    return
                }

                self.displayMessage(title: AlertMessage.cashoutSuccess.title, message: AlertMessage.cashoutSuccess.message)
                self.updateData()
            }
        }
    }
}

extension MyMoneyViewController: ConfirmPasswordCellDelegate {
    func passwordTextFieldDidEnd(text: String) {
        self.password = text
    }
}

extension MyMoneyViewController: PaypalEmailCellDelegate {
    func paypalEmailTextFieldDidEnd(text: String) {
        self.paypalEmail = text

        guard let currentUser = Session.shared.currentUser else { return }
        currentUser.details.paypalEmail = paypalEmail
        currentUser.details.saveInBackground { (success, error) in
            guard success == true, error == nil else {
                self.displayError(error: ErrorMessage.paypalEmailSaveFailed)
                return
            }

            print("PayPal Email Address Saved")
        }
    }
}

extension MyMoneyViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.segmentedControl.selectedSegmentIndex == 0 {
            return 4
        }

        if let myMoney = self.myMoney {
            return myMoney.history.count
        }

        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let myMoney = self.myMoney, let currentUser = Session.shared.currentUser else {
            let cell = UITableViewCell()
            cell.backgroundColor = UIColor.clear
            return cell
        }

        if self.segmentedControl.selectedSegmentIndex == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TotalWithdrawnCell") as! TotalWithdrawnCell
                cell.accessoryType = .none
                cell.selectionStyle = .none
                cell.amountLabel.text = "\(Session.shared.currentCurrencySymbol)\(String(format: "%.2f", myMoney.totalWithdrawn))"
                cell.nameLabel.text = "myMoney.totalWithdrawnCell.title".localized()
                return cell

            } else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "PayPalEmailCell") as! PayPalEmailCell
                cell.accessoryType = .none
                cell.selectionStyle = .none
                cell.nameLabel.text = "myMoney.paypalEmailCell.heading".localized()
                cell.emailTextField.placeholder = "myMoney.paypalEmailCell.placeholder".localized()
                cell.emailTextField.text = currentUser.details.paypalEmail
                self.paypalEmail = currentUser.details.paypalEmail
                cell.delegate = self
                return cell

            } else if indexPath.row == 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ConfirmPasswordCell") as! ConfirmPasswordCell
                cell.accessoryType = .none
                cell.selectionStyle = .none
                cell.nameLabel.text = "myMoney.confirmPasswordCell.heading".localized()
                cell.passwordTextField.placeholder = "myMoney.confirmPasswordCell.placeholder".localized()
                cell.delegate = self
                return cell

            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CashoutCell") as! CashoutCell
                cell.accessoryType = .none
                cell.selectionStyle = .none
                cell.nameLabel.text = "myMoney.cashoutCell.heading".localized()
                cell.amountLabel.text = "\(Session.shared.currentCurrencySymbol)\(String(format: "%.2f", myMoney.moneyAvailable))"
                cell.delegate = self
                return cell
            }
        } else {
            let userCashout = myMoney.history[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "WithdrawnHistoryCell") as! WithdrawnHistoryCell
            cell.accessoryType = .none
            cell.selectionStyle = .none
            cell.amountLabel.text = "\(Session.shared.currentCurrencySymbol)\(String(format: "%.2f", userCashout.value))"
            cell.emailLabel.text = userCashout.paypalEmail

            if let date = userCashout.createdAt {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "d MMMM yyyy"
                cell.dateLabel.text = dateFormatter.string(from: date)
            }

            return cell
        }
    }
}
