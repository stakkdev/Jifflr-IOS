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

    var myTeam: MyTeam? {
        didSet {
            self.tableView.reloadData()

            guard let graphData = self.myTeam?.graph, graphData.count > 0 else { return }
            self.chart.setData(data: self.myTeam!.graph, color: UIColor.mainOrange, fill: true, targetData: nil, targetColor: nil)
        }
    }

    var friends:[MyTeamFriends] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }

    var pendingFriends:[MyTeamPendingFriends] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }

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

        self.segmentedControl.highlightedColor = UIColor.mainOrange
        self.segmentedControl.delegate = self
        self.tableView.estimatedRowHeight = 70.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }

    func setupLocalization() {
        self.title = "myTeam.navigation.title".localized()
        self.segmentedControl.setButton1Title(text: "myTeam.segmentedControlButton1.title".localized())
        self.segmentedControl.setButton2Title(text: "myTeam.segmentedControlButton2.title".localized())
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.updateData()
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
        guard self.myTeam != nil else { return 0 }

        if self.segmentedControl.selectedSegmentIndex == 0 {
            return self.friends.count + 1
        }

        return self.pendingFriends.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let myTeam = self.myTeam else { return UITableViewCell() }

        self.checkForPagination(indexPath: indexPath)

        if self.segmentedControl.selectedSegmentIndex == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TeamSizeCell") as! TeamSizeCell
                cell.accessoryType = .none
                cell.selectionStyle = .none
                cell.sizeLabel.text = "\(myTeam.teamSize)"
                cell.nameLabel.text = "myTeam.teamSize.title".localized()
                return cell

            } else {
                let friend = self.friends[indexPath.row]
                let cell = tableView.dequeueReusableCell(withIdentifier: "TeamFriendCell") as! TeamFriendCell
                cell.accessoryType = .none
                cell.selectionStyle = .none
                cell.nameLabel.text = "\(friend.user.details.firstName) \(friend.user.details.lastName)"
                cell.emailLabel.text = "\(friend.user.email)"
                cell.teamSizeLabel.text = "myTeam.membersLabel.title".localizedFormat(friend.teamSize)

                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd MMM yyyy"
                cell.dateLabel.text = dateFormatter.string(from: friend.date)

                return cell
            }
        } else {
            let pendingFriend = self.pendingFriends[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "TeamPendingFriendCell") as! TeamPendingFriendCell
            cell.accessoryType = .none
            cell.selectionStyle = .none
            cell.nameLabel.text = pendingFriend.pendingUser.name
            cell.emailLabel.text = pendingFriend.pendingUser.email
            cell.codeLabel.text = "myTeam.codeLabel.title".localizedFormat(pendingFriend.pendingUser.invitationCode)

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM yyyy"
            if let createdAt = pendingFriend.pendingUser.createdAt {
                cell.dateLabel.text = dateFormatter.string(from: createdAt)
            }

            cell.setCellActive(isActive: pendingFriend.isActive)

            return cell
        }
    }

    func checkForPagination(indexPath: IndexPath) {
        if self.segmentedControl.selectedSegmentIndex == 0 {
            if TeamPaginationManager.shared.shouldPaginateFriends(indexPath: indexPath, friends: self.friends) {
                if Reachability.isConnectedToNetwork() {
                    self.updateCloudFriends()
                } else {
                    self.updateLocalFriends()
                }
            }
        } else {
            if TeamPaginationManager.shared.shouldPaginatePendingFriends(indexPath: indexPath, pendingFriends: self.pendingFriends) {
                if Reachability.isConnectedToNetwork() {
                    self.updateCloudPendingFriends()
                } else {
                    self.updateLocalPendingFriends()
                }
            }
        }
    }
}

// Data Calls
extension TeamViewController {

    func updateData() {
        TeamPaginationManager.shared.reset()

        if Reachability.isConnectedToNetwork() {
            self.updateCloudData()
        } else {
            self.updateLocalData()
        }
    }

    func updateCloudData() {
        self.updateCloudStats()
        self.updateCloudFriends()
        self.updateCloudPendingFriends()
    }

    func updateCloudStats() {
        MyTeamManager.shared.fetchStats { (myTeam, error) in
            guard let myTeam = myTeam, error == nil else {
                self.displayError(error: error)
                self.updateLocalStats()
                return
            }

            self.myTeam = myTeam
        }
    }

    func updateCloudFriends() {
        guard TeamPaginationManager.shared.shouldPaginateFriends() else { return }

        MyTeamManager.shared.fetchFriends(page: TeamPaginationManager.shared.friendsPageIndex) { (friends, error) in
            TeamPaginationManager.shared.friendsPaginationComplete()

            guard let friends = friends, error == nil else {
                self.displayError(error: error)
                self.updateLocalFriends()
                return
            }

            self.friends += friends
        }
    }

    func updateCloudPendingFriends() {
        guard TeamPaginationManager.shared.shouldPaginatePendingFriends() else { return }

        MyTeamManager.shared.fetchPendingFriends(page: TeamPaginationManager.shared.pendingFriendsPageIndex) { (pendingFriends, error) in
            TeamPaginationManager.shared.pendingFriendsPaginationComplete()

            guard let pendingFriends = pendingFriends, error == nil else {
                self.displayError(error: error)
                self.updateLocalPendingFriends()
                return
            }

            self.pendingFriends += pendingFriends
        }
    }

    func updateLocalData() {
        self.updateLocalStats()
        self.updateLocalFriends()
        self.updateLocalPendingFriends()
    }

    func updateLocalStats() {
        MyTeamManager.shared.fetchLocalStats { (myTeam, error) in
            guard let myTeam = myTeam, error == nil else {
                self.displayError(error: error)
                return
            }

            self.myTeam = myTeam
        }
    }

    func updateLocalFriends() {
        guard TeamPaginationManager.shared.shouldPaginateFriends() else { return }

        MyTeamManager.shared.fetchLocalFriends(page: TeamPaginationManager.shared.friendsPageIndex) { (friends, error) in
            TeamPaginationManager.shared.friendsPaginationComplete()

            guard let friends = friends, error == nil else {
                self.displayError(error: error)
                return
            }

            self.friends += friends
        }
    }

    func updateLocalPendingFriends() {
        guard TeamPaginationManager.shared.shouldPaginatePendingFriends() else { return }

        MyTeamManager.shared.fetchLocalPendingFriends(page: TeamPaginationManager.shared.pendingFriendsPageIndex) { (pendingFriends, error) in
            TeamPaginationManager.shared.pendingFriendsPaginationComplete()

            guard let pendingFriends = pendingFriends, error == nil else {
                self.displayError(error: error)
                return
            }

            self.pendingFriends += pendingFriends
        }
    }
}

extension TeamViewController: CNContactPickerDelegate {
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
//        picker.dismiss(animated: true, completion: {
//
//            guard contact.emailAddresses.count > 0 else {
//                self.displayMessage(title: ErrorMessage.unknown.failureTitle, message: ErrorMessage.unknown.failureDescription)
//                return
//            }
//
//            let name = "\(contact.givenName) \(contact.familyName)"
//            let email = contact.emailAddresses.first!.value as String
//
//            var userInfo = [AnyHashable: Any]()
//            userInfo["name"] = name
//            userInfo["email"] = email
//
//            PendingUserManager.shared.createPendingUser(withUserInfo: userInfo, completion: { (error) in
//                guard error == nil else {
//                    self.displayMessage(title: error!.failureTitle, message: error!.failureDescription)
//                    return
//                }
//
//                self.presentMail(name: name, email: email)
//            })
//        })
    }

    func presentMail(name: String, email: String) {

//        guard MFMailComposeViewController.canSendMail() == true else {
//            self.displayMessage(title: ErrorMessage.inviteSendFailed.failureTitle, message: ErrorMessage.inviteSendFailed.failureDescription)
//            return
//        }
//
//        let composeViewController = MFMailComposeViewController()
//        composeViewController.mailComposeDelegate = self
//        composeViewController.setToRecipients([email])
//        composeViewController.setSubject("Ad-M8 Invite Code!")
//
//        guard let currentUser = UserManager.shared.currentUser else {
//            return
//        }
//        let invitationCode = currentUser.invitationCode
//        let sender = "\(currentUser.firstName) \(currentUser.lastName)"
//
//        let body = "Hello \(name),\n\n\(sender) has sent you an invite code! Here you go: \(invitationCode ?? 0)"
//        composeViewController.setMessageBody(body, isHTML: false)
//
//        self.navigationController?.present(composeViewController, animated: true, completion: nil)
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
