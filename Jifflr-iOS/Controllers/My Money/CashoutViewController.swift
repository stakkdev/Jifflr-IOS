//
//  CashoutViewController.swift
//  Ad-M8-iOS
//
//  Created by James Shaw on 13/10/2017.
//  Copyright © 2017 The Distance. All rights reserved.
//

import UIKit

class CashoutViewController: UIViewController, DisplayMessage {

    @IBOutlet weak var cashOutButton: UIButton!
    @IBOutlet weak var moneyAvailableLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!

    var cashoutData:[UserCashout] = []

    class func instantiateFromStoryboard() -> CashoutViewController {
        let storyboard = UIStoryboard(name: "MyMoney", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "CashoutViewController") as! CashoutViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Cash Out"

        self.tableView.delegate = self
        self.tableView.dataSource = self

        guard let currentUser = UserManager.shared.currentUser else {
            return
        }

        self.moneyAvailableLabel.text = "Money available: 0.0"

        CashoutManager.shared.fetchCashouts(user: currentUser) { userCashouts, error in
            guard error == nil else {
                self.displayMessage(title: error!.failureTitle, message: error!.failureDescription)
                return
            }

            self.cashoutData = userCashouts
            self.tableView.reloadData()
        }
    }

    @IBAction func cashoutButtonPressed(_ sender: UIButton) {
        
    }
}

extension CashoutViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cashoutData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cashoutHistoryCell")
        cell.accessoryType = .none
        cell.selectionStyle = .none
        cell.textLabel?.text = "\(self.cashoutData[indexPath.row].value)"

        if let createdAt = self.cashoutData[indexPath.row].createdAt {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            cell.detailTextLabel?.text = dateFormatter.string(from: createdAt)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
}
