//
//  AdTrackingViewController.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 01/10/2020.
//  Copyright © 2020 The Distance. All rights reserved.
//

import UIKit
import Localize_Swift

class AdTrackingViewController: BaseViewController {

    @IBOutlet weak var enableButton: JifflrButton!
    @IBOutlet weak var descriptionLabel: UILabel!

    class func instantiateFromStoryboard() -> AdTrackingViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "AdTrackingViewController") as! AdTrackingViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
    }

    func setupUI() {
        self.setupLocalization()

        self.setBackgroundImage(image: UIImage(named: "MainBackground"))
        self.enableButton.setBackgroundColor(color: UIColor.mainPink)
        self.navigationItem.setHidesBackButton(true, animated: false)

        if UserDefaultsManager.shared.appTrackingRequested() {
            self.setupPermissionDeniedUI()
        } else {
            self.setupNoPermissionsUI()
        }
    }

    func setupLocalization() {
        self.title = "adTrackingRequired.navigation.title".localized()
        self.enableButton.setTitle("adTrackingRequired.button.title".localized(), for: .normal)
    }

    func setupNoPermissionsUI() {
        self.descriptionLabel.text = "adTrackingRequired.description".localized()
        self.enableButton.isEnabled = true
        self.enableButton.isHidden = false
    }

    func setupPermissionDeniedUI() {
        self.descriptionLabel.text = "adTrackingRequired.permissionDeniedDescription".localized()
        self.enableButton.isHidden = true
        self.enableButton.isEnabled = false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        NotificationCenter.default.addObserver(self, selector: #selector(checkPermissions), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        NotificationCenter.default.removeObserver(self)
    }

    @IBAction func enableButtonPressed(_ sender: UIButton) {
        AdTrackingManager.shared.requestPermissions { (granted) in
            DispatchQueue.main.async {
                if granted {
                    self.rootDashboardViewController()
                } else {
                    self.setupPermissionDeniedUI()
                }
            }
        }
    }

    @objc func checkPermissions() {
        if AdTrackingManager.shared.adTrackingEnabled() {
            self.rootDashboardViewController()
        }
    }
}
