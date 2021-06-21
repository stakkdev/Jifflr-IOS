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
    
    var noCMSAds = false

    class func instantiateFromStoryboard(noCMSAds: Bool = false) -> AdTrackingViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AdTrackingViewController") as! AdTrackingViewController
        vc.noCMSAds = noCMSAds
        return vc
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
        
        if self.noCMSAds {
            self.setupNoCMSAdsUI()
        } else if UserDefaultsManager.shared.appTrackingRequested() {
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
        self.enableButton.tag = 0
        self.enableButton.setTitle("adTrackingRequired.button.title".localized(), for: .normal)
    }

    func setupPermissionDeniedUI() {
        self.descriptionLabel.text = "adTrackingRequired.permissionDeniedDescription".localized()
        self.enableButton.isHidden = false
        self.enableButton.isEnabled = true
        self.enableButton.tag = 1
        self.enableButton.setTitle("adTrackingRequired.button.titlePermissionDenied".localized(), for: .normal)
    }
    
    func setupNoCMSAdsUI() {
        self.descriptionLabel.text = "adTrackingRequired.noCMSAdsDescription".localized()
        self.enableButton.isHidden = false
        self.enableButton.isEnabled = true
        self.enableButton.tag = 1
        self.enableButton.setTitle("adTrackingRequired.button.titlePermissionDenied".localized(), for: .normal)
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
        if sender.tag == 0 {
            AdTrackingManager.shared.requestPermissions { (granted) in
                DispatchQueue.main.async {
                    if granted {
                        self.rootDashboardViewController()
                    } else {
                        self.setupPermissionDeniedUI()
                    }
                }
            }
        } else {
            self.rootDashboardViewController()
        }
    }

    @objc func checkPermissions() {
        if AdTrackingManager.shared.adTrackingEnabled() {
            self.rootDashboardViewController()
        }
    }
}
