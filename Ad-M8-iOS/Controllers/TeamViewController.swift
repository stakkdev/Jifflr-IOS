//
//  TeamViewController.swift
//  Ad-M8-iOS
//
//  Created by James Shaw on 10/10/2017.
//  Copyright © 2017 The Distance. All rights reserved.
//

import UIKit

class TeamViewController: UIViewController, DisplayMessage {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!

    var pendingFriendsData:[PendingUser] = []
    var friendsData:[String] = []

    class func instantiateFromStoryboard() -> TeamViewController {
        let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "TeamViewController") as! TeamViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Team"

        self.tableView.dataSource = self
        self.tableView.delegate = self

        let addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addButtonPressed(_:)))
        self.navigationItem.rightBarButtonItem = addBarButton

        PendingUserManager.shared.fetchPendingUsers { (pendingUsers, error) in
            guard pendingUsers.count > 0, error == nil else {
                self.displayMessage(title: error!.failureTitle, message: error!.failureDescription)
                return
            }

            self.pendingFriendsData = pendingUsers

            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    @objc func addButtonPressed(_ sender: UIBarButtonItem) {

    }

    @IBAction func valueChanged(_ sender: UISegmentedControl) {
        self.tableView.reloadData()
    }
}

extension TeamViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.segmentedControl.selectedSegmentIndex == 0 {
            return 4//self.friendsData.count
        }

        return self.pendingFriendsData.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "teamCell")
        cell.accessoryType = .none
        cell.selectionStyle = .none

        if self.segmentedControl.selectedSegmentIndex == 0 {
            cell.textLabel?.text = "James Shaw"
            cell.detailTextLabel?.text = "james.shaw@thedistance.co.uk"
        } else {
            cell.textLabel?.text = "Bob Smith"
            cell.detailTextLabel?.text = "bob.smith@thedistance.co.uk"
        }

        return cell
    }
}
