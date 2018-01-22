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
    @IBOutlet weak var noOfFriendsLabel: UILabel!
    @IBOutlet weak var noOfAdvertViewsLabel: UILabel!

    class func presentAsRootViewController() {
        let navigationController = UINavigationController()
        navigationController.viewControllers = [self.instantiateFromStoryboard()]
        navigationController.setNavigationBarHidden(false, animated: false)
        UIApplication.shared.delegate?.window??.rootViewController = navigationController
    }

    class func instantiateFromStoryboard() -> DashboardViewController {
        let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Ad-M8"

        let profileBarButton = UIBarButtonItem(title: "Profile", style: .plain, target: self, action: #selector(self.profileButtonPressed(_:)))
        self.navigationItem.rightBarButtonItem = profileBarButton
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let currentUser = UserManager.shared.currentUser {
            self.noOfFriendsLabel.text = "Team Size: \(currentUser.friends.count)"

            AdvertManager.shared.fetchNumberOfAdvertViews(user: currentUser, completion: { (count) in
                self.noOfAdvertViewsLabel.text = "Advert Views: \(count)"
            })
        }
    }

    @objc func profileButtonPressed(_ sender: UIBarButtonItem) {

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
