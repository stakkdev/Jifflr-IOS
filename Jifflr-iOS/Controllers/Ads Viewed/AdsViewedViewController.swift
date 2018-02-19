//
//  AdsViewedViewController.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 16/02/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit

class AdsViewedViewController: BaseViewController {

    @IBOutlet weak var segmentedControl: JifflrSegmentedControl!
    @IBOutlet weak var chart: JifflrTeamChart!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeaderView: UIView!

    class func instantiateFromStoryboard() -> AdsViewedViewController {
        let storyboard = UIStoryboard(name: "AdsViewed", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "AdsViewedViewController") as! AdsViewedViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
    }

    func setupUI() {
        self.setupLocalization()

        self.setBackgroundImage(image: UIImage(named: "MainBackground"))
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.setHidesBackButton(false, animated: false)

        self.segmentedControl.highlightedColor = UIColor.mainPinkBright
        self.segmentedControl.delegate = self
        self.tableView.estimatedRowHeight = 70.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.dataSource = self
        self.tableView.delegate = self

        self.chart.setData(data: MockContent.init().createGraphData(), color: UIColor.mainPinkBright, fill: false)
    }

    func setupLocalization() {
        self.title = "adsViewed.navigation.title".localized()
        self.segmentedControl.setButton1Title(text: "adsViewed.segmentedControlButton1.title".localized())
        self.segmentedControl.setButton2Title(text: "adsViewed.segmentedControlButton2.title".localized())
    }
}

extension AdsViewedViewController: JifflrSegmentedControlDelegate {
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

extension AdsViewedViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.segmentedControl.selectedSegmentIndex == 0 {
            return 4
        }

        return 20
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if self.segmentedControl.selectedSegmentIndex == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AdsViewedCell") as! AdsViewedCell
                cell.accessoryType = .none
                cell.selectionStyle = .none
                cell.sizeLabel.text = "9103"
                cell.nameLabel.text = "adsViewed.adsViewedCell.title".localized()
                return cell

            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AdsViewedDetailCell") as! AdsViewedDetailCell
                cell.accessoryType = .none
                cell.selectionStyle = .none

                switch indexPath.row {
                case 1:
                    cell.mainLabel.text = "adsViewed.targetLabel.title".localizedFormat(14)
                    cell.detailLabel.text = "adsViewed.detailLabel.title".localized()
                    cell.rightLabel.text = ""
                case 2:
                    cell.mainLabel.text = "adsViewed.adBacklog.title".localized()
                    cell.detailLabel.text = "adsViewed.adBacklogMinimum.title".localizedFormat(5)
                    cell.rightLabel.text = "0"
                case 3:
                    cell.mainLabel.text = "adsViewed.percentageDue.title".localized()
                    cell.detailLabel.text = "adsViewed.percentageDue.detail".localized()
                    cell.rightLabel.text = "42%"
                default:
                    cell.mainLabel.text = "adsViewed.targetLabel.title".localizedFormat(14)
                    cell.detailLabel.text = "adsViewed.detailLabel.title".localized()
                    cell.rightLabel.text = ""
                }

                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AdHistoryCell") as! AdHistoryCell
            cell.accessoryType = .none
            cell.selectionStyle = .none
            cell.monthLabel.text = "February 2018"
            cell.percentageLabel.text = "95%"

            return cell
        }
    }
}
