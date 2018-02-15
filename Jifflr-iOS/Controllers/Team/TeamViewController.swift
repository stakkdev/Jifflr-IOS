//
//  TeamViewController.swift
//  Ad-M8-iOS
//
//  Created by James Shaw on 10/10/2017.
//  Copyright © 2017 The Distance. All rights reserved.
//

import UIKit
import ContactsUI
import MessageUI
import Parse

class TeamViewController: BaseViewController {

    @IBOutlet weak var segmentedControl: JifflrSegmentedControl!
    @IBOutlet weak var chart: JifflrTeamChart!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeaderView: UIView!

    var pendingFriendsData:[PendingUser] = []
    var friendsData:[PFUser] = []

    class func instantiateFromStoryboard() -> TeamViewController {
        let storyboard = UIStoryboard(name: "MyTeam", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "TeamViewController") as! TeamViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
    }

    func setupUI() {
        self.setupLocalization()

        let addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addButtonPressed(_:)))
        self.navigationItem.rightBarButtonItem = addBarButton

        self.setBackgroundImage(image: UIImage(named: "MainBackground"))
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.setHidesBackButton(false, animated: false)

        self.segmentedControl.delegate = self
        self.tableView.estimatedRowHeight = 70.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.dataSource = self
        self.tableView.delegate = self

        self.chart.setData(data: [(x: 0.0, y: 0.0), (x: 10.0, y: 10.0), (x: 20.0, y: 20.0),(x: 30.0, y: 30.0), (x: 40.0, y: 40.0),(x: 50.0, y: 50.0),(x: 60.0, y: 60.0), (x: 70.0, y: 70.0), (x: 80.0, y: 80.0), (x: 90.0, y: 90.0), (x: 100.0, y: 100.0), (x: 110.0, y: 110.0), (x: 120.0, y: 120.0), (x: 130.0, y: 130.0), (x: 140.0, y: 140.0), (x: 150.0, y: 150.0), (x: 160.0, y: 160.0), (x: 170.0, y: 170.0), (x: 180.0, y: 180.0), (x: 190.0, y: 190.0), (x: 200.0, y: 200.0)])
    }

    func setupLocalization() {
        self.title = "myTeam.navigation.title".localized()
        self.segmentedControl.setButton1Title(text: "myTeam.segmentedControlButton1.title".localized())
        self.segmentedControl.setButton2Title(text: "myTeam.segmentedControlButton2.title".localized())
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let group = DispatchGroup()

        group.enter()
        PendingUserManager.shared.fetchPendingUsers { (pendingUsers, error) in
            guard error == nil else {
                group.leave()
                self.displayMessage(title: error!.failureTitle, message: error!.failureDescription)
                return
            }

            self.pendingFriendsData = pendingUsers
            group.leave()
        }

        group.enter()
        UserManager.shared.currentUser?.fetchFriends(completion: { (friends) in
            self.friendsData = friends
            group.leave()
        })

        group.notify(queue: DispatchQueue.main) {
            self.tableView.reloadData()
        }
    }

    @objc func addButtonPressed(_ sender: UIBarButtonItem) {
        ContactsManager.shared.requestAccess { (access) in
            guard access == true else {
                self.displayMessage(title: ErrorMessage.contactsAccessFailed.failureTitle, message: ErrorMessage.contactsAccessFailed.failureDescription)
                return
            }

            let contactPickerViewController = CNContactPickerViewController()
            contactPickerViewController.delegate = self
            contactPickerViewController.displayedPropertyKeys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactEmailAddressesKey]
            self.navigationController?.present(contactPickerViewController, animated: true, completion: nil)
        }
    }
}

extension TeamViewController: JifflrSegmentedControlDelegate {
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

extension TeamViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.segmentedControl.selectedSegmentIndex == 0 {
            return 3//self.friendsData.count
        }

        return 2//self.pendingFriendsData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if self.segmentedControl.selectedSegmentIndex == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TeamSizeCell") as! TeamSizeCell
                cell.accessoryType = .none
                cell.selectionStyle = .none
                cell.sizeLabel.text = "1111"
                return cell

            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TeamFriendCell") as! TeamFriendCell
                cell.accessoryType = .none
                cell.selectionStyle = .none
                cell.nameLabel.text = "James Shaw"
                cell.emailLabel.text = "james@thedistance.co.uk"
                cell.teamSizeLabel.text = "100 Members"
                cell.dateLabel.text = "6 April 2016"
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TeamPendingFriendCell") as! TeamPendingFriendCell
            cell.accessoryType = .none
            cell.selectionStyle = .none
            cell.nameLabel.text = "James Shaw"
            cell.emailLabel.text = "james@thedistance.co.uk"
            cell.codeLabel.text = "CODE xBgFs12"
            cell.dateLabel.text = "6 April 2016"

            if indexPath.row == 0 {
                cell.roundedView.alpha = 1.0
            } else {
                cell.roundedView.alpha = 0.6
            }

            return cell
        }
    }
}

extension TeamViewController: CNContactPickerDelegate {
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        picker.dismiss(animated: true, completion: {

            guard contact.emailAddresses.count > 0 else {
                self.displayMessage(title: ErrorMessage.unknown.failureTitle, message: ErrorMessage.unknown.failureDescription)
                return
            }

            let name = "\(contact.givenName) \(contact.familyName)"
            let email = contact.emailAddresses.first!.value as String

            var userInfo = [AnyHashable: Any]()
            userInfo["name"] = name
            userInfo["email"] = email

            PendingUserManager.shared.createPendingUser(withUserInfo: userInfo, completion: { (error) in
                guard error == nil else {
                    self.displayMessage(title: error!.failureTitle, message: error!.failureDescription)
                    return
                }

                self.presentMail(name: name, email: email)
            })
        })
    }

    func presentMail(name: String, email: String) {

        guard MFMailComposeViewController.canSendMail() == true else {
            self.displayMessage(title: ErrorMessage.inviteSendFailed.failureTitle, message: ErrorMessage.inviteSendFailed.failureDescription)
            return
        }

        let composeViewController = MFMailComposeViewController()
        composeViewController.mailComposeDelegate = self
        composeViewController.setToRecipients([email])
        composeViewController.setSubject("Ad-M8 Invite Code!")

        guard let currentUser = UserManager.shared.currentUser else {
            return
        }
        let invitationCode = currentUser.invitationCode
        let sender = "\(currentUser.firstName) \(currentUser.lastName)"

        let body = "Hello \(name),\n\n\(sender) has sent you an invite code! Here you go: \(invitationCode ?? 0)"
        composeViewController.setMessageBody(body, isHTML: false)

        self.navigationController?.present(composeViewController, animated: true, completion: nil)
    }
}

extension TeamViewController: MFMailComposeViewControllerDelegate {

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {

        controller.dismiss(animated: true, completion: {
            if error == nil {
                if result == MFMailComposeResult.sent {
                    let title = "Invite Sent!"
                    let message = "Your invitation has been sent!"
                    self.displayMessage(title: title, message: message, dismissText: "Okay", dismissAction: { action in })
                }
            } else {
                self.displayMessage(title: ErrorMessage.inviteSendFailed.failureTitle, message: ErrorMessage.inviteSendFailed.failureDescription)
            }
        })
    }
}
