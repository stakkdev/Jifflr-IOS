//
//  NonComplianceViewController.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 03/05/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit

class NonComplianceViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var campaign: Campaign!
    var moderatorFeedbacks: [ModeratorFeedback] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }

    class func instantiateFromStoryboard(campaign: Campaign) -> NonComplianceViewController {
        let storyboard = UIStoryboard(name: "Moderation", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "NonComplianceViewController") as! NonComplianceViewController
        vc.campaign = campaign
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.setupUI()
        self.setupData()
    }
    
    func setupUI() {
        self.setupLocalization()
        self.setBackgroundImage(image: UIImage(named: "MainBackground"))
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.setHidesBackButton(false, animated: true)
        self.tableView.backgroundColor = UIColor.clear

        self.tableView.estimatedRowHeight = 60.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.separatorColor = UIColor.clear
    }
    
    func setupLocalization() {
        self.title = "nonCompliance.navigation.title".localized()
    }
    
    func setupData() {
        self.spinner.startAnimating()
        ModerationManager.shared.fetchNonComplianceFeedback(campaign: self.campaign) { (moderatorFeedback) in
            self.moderatorFeedbacks = moderatorFeedback
            self.spinner.stopAnimating()
        }
    }
}

extension NonComplianceViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.moderatorFeedbacks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NonComplianceCell") as! NonComplianceCell
        cell.accessoryType = .none
        cell.selectionStyle = .none
        
        let rowNumber = indexPath.row + 1
        cell.titleLabel.text = "\(rowNumber). \(self.moderatorFeedbacks[indexPath.row].category.title)"
        cell.descriptionLabel.text = self.moderatorFeedbacks[indexPath.row].title
        
        return cell
    }
}
