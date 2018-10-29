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
    
    var myAds: MyAds?
    
    class func instantiateFromStoryboard(myAds: MyAds?) -> AdBuilderOverviewViewController {
        let storyboard = UIStoryboard(name: "AdBuilderOverview", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AdBuilderOverviewViewController") as! AdBuilderOverviewViewController
        vc.myAds = myAds
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        self.updateNavigationStack()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.updateData()
        
        if self.myAds != nil {
            self.updateUI()
        }
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
        
        let addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addButtonPressed))
        addBarButton.tintColor = UIColor.white
        addBarButton.isEnabled = true
        self.navigationItem.rightBarButtonItem = addBarButton
        
        self.barChart.startSpinner()
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
    
    func updateUI() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            
            guard let points = self.myAds?.graph, points.count > 0 else {
                self.barChart.showNoDataLabel()
                return
            }
            
            self.barChart.stopSpinner()
            self.barChart.setupData(points: points)
        }
    }
    
    @objc func addButtonPressed() {
        if self.segmentedControl.selectedSegmentIndex == 0 {
            let vc = CreateScheduleViewController.instantiateFromStoryboard(advert: nil, campaign: nil, isEdit: false)
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            self.navigationController?.pushViewController(CreateAdViewController.instantiateFromStoryboard(advert: nil), animated: true)
        }
    }
    
    func updateData() {
        if Reachability.isConnectedToNetwork() {
            self.updateCloudData()
        } else {
            self.updateLocalData()
        }
    }
    
    func updateCloudData() {
        MyAdsManager.shared.fetchData { (myAds) in
            guard let myAds = myAds else {
                self.updateLocalData()
                return
            }
            
            self.myAds = myAds
            self.updateUI()
        }
    }
    
    func updateLocalData() {
        MyAdsManager.shared.fetchLocalData { (myAds) in
            guard let myAds = myAds else {
                self.displayError(error: ErrorMessage.adBuilderOverviewFetchFailed)
                return
            }
            
            self.myAds = myAds
            self.updateUI()
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
            self.tableViewHeaderView.frame.size.height = 260.0
        }
        
        self.tableView.reloadData()
    }
}

extension AdBuilderOverviewViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let myAds = self.myAds else { return 0 }
        
        if self.segmentedControl.selectedSegmentIndex == 0 {
            return myAds.campaigns.count + 1
        }
        
        return myAds.adverts.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let myAds = self.myAds else { return UITableViewCell() }
        
        if self.segmentedControl.selectedSegmentIndex == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ActiveAdsCell") as! ActiveAdsCell
                cell.nameLabel.text = "adBuilderOverview.totalCampaigns.text".localized()
                cell.sizeLabel.text = "\(myAds.campaignCount)"
                cell.accessoryType = .none
                cell.selectionStyle = .none
                return cell
                
            } else {
                let campaign = myAds.campaigns[indexPath.row - 1]
                let cell = tableView.dequeueReusableCell(withIdentifier: "AdvertCell") as! AdvertCell
                cell.accessoryType = .none
                cell.selectionStyle = .none
                cell.nameLabel.text = campaign.name
                cell.idLabel.text = "C# \(campaign.number)"
                cell.statusLabel.text = "adBuilderOverview.status.text".localized()
                cell.handleStatus(status: campaign.status)
                cell.handleDate(createdAt: campaign.createdAt)
                cell.shouldHideStatus(yes: false)
                
                return cell
            }
        } else {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ActiveAdsCell") as! ActiveAdsCell
                cell.nameLabel.text = "adBuilderOverview.myActiveAds.text".localized()
                cell.sizeLabel.text = "\(myAds.activeAds)"
                cell.accessoryType = .none
                cell.selectionStyle = .none
                return cell
                
            } else {
                let advert = myAds.adverts[indexPath.row - 1]
                let cell = tableView.dequeueReusableCell(withIdentifier: "AdvertCell") as! AdvertCell
                cell.accessoryType = .none
                cell.selectionStyle = .none
                cell.nameLabel.text = advert.details?.name
                cell.idLabel.text = "A# \(advert.details?.number ?? 0)"
                cell.statusLabel.text = "adBuilderOverview.status.text".localized()
                cell.handleDate(createdAt: advert.createdAt)
                cell.shouldHideStatus(yes: true)
                
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.segmentedControl.selectedSegmentIndex == 1 {
            guard indexPath.row > 0 else { return }
            guard let advert = self.myAds?.adverts[indexPath.row - 1] else { return }
            let vc = CreateAdViewController.instantiateFromStoryboard(advert: advert)
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            guard indexPath.row > 0 else { return }
            guard let campaign = self.myAds?.campaigns[indexPath.row - 1] else { return }
            let vc = CampaignOverviewViewController.instantiateFromStoryboard(campaign: campaign)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
