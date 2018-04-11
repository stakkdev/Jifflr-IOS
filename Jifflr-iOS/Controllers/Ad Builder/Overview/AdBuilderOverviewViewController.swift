//
//  AdBuilderOverviewViewController.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 26/03/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit

class AdBuilderOverviewViewController: BaseViewController {
    
    @IBOutlet weak var segmentedControl: JifflrSegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeaderView: UIView!
    @IBOutlet weak var barChart: JifflrBarChart!
    
    class func instantiateFromStoryboard() -> AdBuilderOverviewViewController {
        let storyboard = UIStoryboard(name: "AdBuilderOverview", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "AdBuilderOverviewViewController") as! AdBuilderOverviewViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        self.updateNavigationStack()
    }
    
    func setupUI() {
        self.setupLocalization()
        
        self.setBackgroundImage(image: UIImage(named: "MainBackground"))
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.setHidesBackButton(false, animated: false)
        
        self.segmentedControl.highlightedColor = UIColor.mainLightBlue
        self.segmentedControl.delegate = self
        self.tableView.estimatedRowHeight = 70.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    func setupLocalization() {
        self.title = "adBuilderOverview.navigation.title".localized()
        self.segmentedControl.setButton1Title(text: "adBuilderOverview.segmentedControlButton1.title".localized())
        self.segmentedControl.setButton2Title(text: "adBuilderOverview.segmentedControlButton2.title".localized())
    }
    
    func updateNavigationStack() {
        guard let navController = self.navigationController else { return }
        for (index, viewController) in navController.viewControllers.enumerated() {
            if let _ = viewController as? AdBuilderLandingViewController {
                navController.viewControllers.remove(at: index)
                return
            }
        }
    }
}

extension AdBuilderOverviewViewController: JifflrSegmentedControlDelegate {
    func valueChanged() {
        if self.segmentedControl.selectedSegmentIndex == 0 {
            self.tableView.contentOffset.y = 0.0
            self.tableViewHeaderView.frame.size.height = 260.0
        } else {
            self.tableView.contentOffset.y = 200.0
            self.tableViewHeaderView.frame.size.height = 280.0
        }
        
        self.tableView.reloadData()
    }
}

extension AdBuilderOverviewViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.segmentedControl.selectedSegmentIndex == 0 {
            return 5
        }
        
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.segmentedControl.selectedSegmentIndex == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ActiveAdsCell") as! ActiveAdsCell
                cell.nameLabel.text = "adBuilderOverview.totalCampaigns.text".localized()
                cell.sizeLabel.text = "\(3)"
                cell.accessoryType = .none
                cell.selectionStyle = .none
                return cell
                
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AdvertCell") as! AdvertCell
                cell.accessoryType = .none
                cell.selectionStyle = .none
                cell.nameLabel.text = "Red Lion Pub Quiz"
                cell.dateLabel.text = "22 June 2017"
                cell.idLabel.text = "C# 3"
                cell.statusLabel.text = "adBuilderOverview.status.text".localized()
                cell.statusImageView.backgroundColor = UIColor.mainGreen
                cell.statusImageView.layer.cornerRadius = 7.0
                cell.statusImageView.layer.masksToBounds = true
                
                return cell
            }
        } else {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ActiveAdsCell") as! ActiveAdsCell
                cell.nameLabel.text = "adBuilderOverview.myActiveAds.text".localized()
                cell.sizeLabel.text = "\(10)"
                cell.accessoryType = .none
                cell.selectionStyle = .none
                return cell
                
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AdvertCell") as! AdvertCell
                cell.accessoryType = .none
                cell.selectionStyle = .none
                cell.nameLabel.text = "Early bird"
                cell.dateLabel.text = "4 August 2017"
                cell.idLabel.text = "NBIDFNID"
                cell.statusLabel.text = "adBuilderOverview.status.text".localized()
                cell.statusImageView.backgroundColor = UIColor.mainGreen
                cell.statusImageView.layer.cornerRadius = 7.0
                cell.statusImageView.layer.masksToBounds = true
                
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}
