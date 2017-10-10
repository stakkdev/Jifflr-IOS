//
//  DashboardViewController.swift
//  Ad-M8-iOS
//
//  Created by James Shaw on 10/10/2017.
//  Copyright © 2017 The Distance. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {

    @IBOutlet weak var playAdsButton: UIButton!
    @IBOutlet weak var teamButton: UIButton!
    @IBOutlet weak var cashOutButton: UIButton!
    @IBOutlet weak var earningsButton: UIButton!
    @IBOutlet weak var adsViewedButton: UIButton!
    @IBOutlet weak var helpButton: UIButton!

    class func presentAsRootViewController() {
        let navigationController = UINavigationController()
        navigationController.viewControllers = [self.instantiateFromStoryboard()]
        navigationController.setNavigationBarHidden(false, animated: false)
        UIApplication.shared.delegate?.window??.rootViewController = navigationController
    }

    class func instantiateFromStoryboard() -> DashboardViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Ad-M8"

        let profileBarButton = UIBarButtonItem(title: "Profile", style: .plain, target: self, action: #selector(self.profileButtonPressed(_:)))
        self.navigationItem.rightBarButtonItem = profileBarButton
    }

    @objc func profileButtonPressed(_ sender: UIBarButtonItem) {

    }

    @IBAction func playAdsButtonPressed(_ sender: UIButton) {

    }

    @IBAction func teamButtonPressed(_ sender: UIButton) {

    }

    @IBAction func cashOutButtonPressed(_ sender: UIButton) {

    }
}
