//
//  DashboardViewController.swift
//  Ad-M8-iOS
//
//  Created by James Shaw on 10/10/2017.
//  Copyright © 2017 The Distance. All rights reserved.
//

import UIKit

class DashboardViewController: BaseViewController {

    @IBOutlet weak var playAdsButton: UIButton!
    @IBOutlet weak var myTeamButton: DashboardButtonLeft!
    @IBOutlet weak var myMoneyButton: DashboardButtonLeft!
    @IBOutlet weak var adBuilderButton: DashboardButtonRight!
    @IBOutlet weak var adsViewedButton: DashboardButtonRight!
    @IBOutlet weak var helpButton: JifflrButton!

    class func instantiateFromStoryboard() -> DashboardViewController {
        let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
    }

    func setupUI() {
        self.setupLocalization()

        self.setBackgroundImage(image: UIImage(named: "DashboardBackground"))

        self.helpButton.setBackgroundColor(color: UIColor.mainBlueTransparent80)
        self.myTeamButton.setBackgroundColor(color: UIColor.mainOrange)
        self.adsViewedButton.setBackgroundColor(color: UIColor.mainPink)
        self.myMoneyButton.setBackgroundColor(color: UIColor.mainGreen)
        self.adBuilderButton.setBackgroundColor(color: UIColor.mainLightBlue)
    }

    func setupLocalization() {

    }

    @IBAction func profileButtonPressed(sender: UIButton) {

    }

    @IBAction func playAdsButtonPressed(_ sender: UIButton) {
        self.navigationController?.present(AdvertViewController.instantiateFromStoryboard(), animated: true, completion: nil)
    }

    @IBAction func teamButtonPressed(_ sender: UIButton) {
        self.navigationController?.pushViewController(TeamViewController.instantiateFromStoryboard(), animated: true)
    }

    @IBAction func cashOutButtonPressed(_ sender: UIButton) {
        self.navigationController?.pushViewController(CashoutViewController.instantiateFromStoryboard(), animated: true)
    }
}
