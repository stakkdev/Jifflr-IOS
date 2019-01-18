//
//  TeamViewController.swift
//  Ad-M8-iOS
//
//  Created by James Shaw on 10/10/2017.
//  Copyright © 2017 The Distance. All rights reserved.
//

import UIKit
import Parse

class TeamViewController: BaseViewController {

    @IBOutlet weak var segmentedControl: JifflrSegmentedControl!
    @IBOutlet weak var chart: JifflrTeamChart!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeaderView: UIView!

    var myTeam: MyTeam? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                
                guard let graphData = self.myTeam?.graph, graphData.count > 0 else {
                    self.chart.showNoDataLabel()
                    return
                }
                self.chart.setData(data: graphData, color: UIColor.mainOrange, fill: true, targetData: nil, targetColor: nil)
            }
        }
    }

    var friends:[MyTeamFriends] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    var pendingFriends:[PendingUser] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    var pendingUser: PendingUser?
    var isDismissingContacts = false

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
        self.tableView.estimatedSectionHeaderHeight = 0.0
        self.tableView.estimatedSectionFooterHeight = 0.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.chart.startSpinner()
    }

    func setupLocalization() {
        self.title = "myTeam.navigation.title".localized()
        self.segmentedControl.setButton1Title(text: "myTeam.segmentedControlButton1.title".localized())
        self.segmentedControl.setButton2Title(text: "myTeam.segmentedControlButton2.title".localized())
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !self.isDismissingContacts {
            DispatchQueue.global(qos: .background).async {
                self.updateData()
            }
        }
        self.isDismissingContacts = false
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
            guard self.myTeam != nil else { return 0 }
            return self.friends.count + 1
        }

        return self.pendingFriends.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        self.checkForPagination(indexPath: indexPath)

        if self.segmentedControl.selectedSegmentIndex == 0 {
            guard let myTeam = self.myTeam else { return UITableViewCell() }
            
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TeamSizeCell") as! TeamSizeCell
                cell.accessoryType = .none
                cell.selectionStyle = .none
                cell.sizeLabel.text = "\(myTeam.teamSize)"
                cell.nameLabel.text = "myTeam.teamSize.title".localized()
                return cell

            } else {
                let friend = self.friends[indexPath.row - 1]
                let cell = tableView.dequeueReusableCell(withIdentifier: "TeamFriendCell") as! TeamFriendCell
                cell.accessoryType = .none
                cell.selectionStyle = .none
                cell.teamSizeLabel.text = "myTeam.membersLabel.title".localizedFormat(friend.teamSize)
                cell.teamSizeLabel.sizeToFit()
                cell.nameLabel.text = "\(friend.user.details.firstName) \(friend.user.details.lastName)"
                cell.emailLabel.text = "\(friend.user.username ?? "")"

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
            cell.nameLabel.text = pendingFriend.name
            cell.emailLabel.text = pendingFriend.email
            cell.codeLabel.text = "myTeam.codeLabel.title".localizedFormat(pendingFriend.invitationCode)

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM yyyy"
            if let createdAt = pendingFriend.createdAt {
                cell.dateLabel.text = dateFormatter.string(from: createdAt)
            }

            cell.setCellActive(isActive: !pendingFriend.isSignedUp)

            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard self.segmentedControl.selectedSegmentIndex == 1 else { return }

        let pendingFriend = self.pendingFriends[indexPath.row]
        guard !pendingFriend.isSignedUp else { return }
        
        let viewController = ChangeInvitationViewController.instantiateFromStoryboard(pendingUser: pendingFriend)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if self.segmentedControl.selectedSegmentIndex == 0 {
            return indexPath.row != 0
        }
        
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .normal, title: "alert.deleteFriend.deleteButton".localized()) { (rowAction, indexPath) -> Void in
            self.deleteAtIndexPath(indexPath: indexPath)
        }
        deleteAction.backgroundColor = UIColor(white: 1.0, alpha: 0.0)
        deleteAction.backgroundEffect = nil
        
        return [deleteAction]
    }
    
    func deleteAtIndexPath(indexPath: IndexPath) {
        if self.segmentedControl.selectedSegmentIndex == 0 {
            let title = "feedback.dismissSwipeAlert.title".localized()
            let message = "alert.deleteFriend.message".localized()
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "alert.notifications.cancelButton".localized(), style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            let deleteAction = UIAlertAction(title: "alert.deleteFriend.deleteButton".localized(), style: .destructive) { (action) in
                
                let friend = self.friends[indexPath.row - 1]
                MyTeamManager.shared.deleteFriend(friend: friend.user) { (error) in
                    guard error == nil else {
                        self.displayError(error: error)
                        return
                    }
                    
                    self.tableView.beginUpdates()
                    self.friends.remove(at: indexPath.row - 1)
                    let deleteIndexPath = IndexPath(row: indexPath.row - 1, section: 0)
                    self.tableView.deleteRows(at: [deleteIndexPath], with: .none)
                    self.tableView.endUpdates()
                }
            }
            alertController.addAction(deleteAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            let title = "feedback.dismissSwipeAlert.title".localized()
            let message = "alert.deletePendingFriend.message".localized()
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "alert.notifications.cancelButton".localized(), style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            let deleteAction = UIAlertAction(title: "alert.deleteFriend.deleteButton".localized(), style: .destructive) { (action) in
                
                let pendingUser = self.pendingFriends[indexPath.row]
                PendingUserManager.shared.deleteAndUnpinPendingUser(pendingUser: pendingUser) { (error) in
                    guard error == nil else {
                        self.displayError(error: error)
                        return
                    }
                    
                    self.pendingFriends.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .none)
                }
            }
            alertController.addAction(deleteAction)
            self.present(alertController, animated: true, completion: nil)
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
        self.pendingFriends = []
        self.friends = []

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
                self.chart.showNoDataLabel()
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
