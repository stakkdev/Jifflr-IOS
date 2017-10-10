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
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

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
            return self.friendsData.count
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
            let pendingUser = self.pendingFriendsData[indexPath.row]
            cell.textLabel?.text = pendingUser.name
            cell.detailTextLabel?.text = pendingUser.email
        }

        return cell
    }
}

extension TeamViewController: CNContactPickerDelegate {
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        picker.dismiss(animated: true, completion: {

            guard contact.emailAddresses.count > 0 else {
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

        let body = "Hello \(name),\n\n\(sender) has sent you an invite code! Here you go: \(invitationCode)"
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
