//
//  SettingsViewController.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 20/02/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit

class SettingsViewController: BaseViewController {

    @IBOutlet weak var scrollView: UIScrollView!

    class func instantiateFromStoryboard() -> SettingsViewController {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
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
    }

    func setupLocalization() {
        self.title = "settings.navigation.title".localized()
    }
}
