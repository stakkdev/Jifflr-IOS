//
//  LocationRequiredViewController.swift
//  Ad-M8-iOS
//
//  Created by James Shaw on 10/10/2017.
//  Copyright © 2017 The Distance. All rights reserved.
//

import UIKit
import CoreLocation
import Localize_Swift

class LocationRequiredViewController: BaseViewController {

    @IBOutlet weak var enableButton: JifflrButton!
    @IBOutlet weak var descriptionLabel: UILabel!

    class func instantiateFromStoryboard() -> LocationRequiredViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "LocationRequiredViewController") as! LocationRequiredViewController
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

        if UserDefaultsManager.shared.locationPermissionsRequested() {
            self.setupPermissionDeniedUI()
        } else {
            self.setupNoPermissionsUI()
        }
    }

    func setupLocalization() {
        self.title = "locationRequired.navigation.title".localized()
        self.enableButton.setTitle("locationRequired.button.title".localized(), for: .normal)
    }

    func setupNoPermissionsUI() {
        self.descriptionLabel.text = "locationRequired.description".localized()
        self.enableButton.isEnabled = true
        self.enableButton.isHidden = false
    }

    func setupPermissionDeniedUI() {
        self.descriptionLabel.text = "locationRequired.permissionDeniedDescription".localized()
        self.enableButton.isHidden = true
        self.enableButton.isEnabled = false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        NotificationCenter.default.addObserver(self, selector: #selector(locationPermissionsChanged(_:)), name: Constants.Notifications.locationPermissionsChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(checkPermissions), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        NotificationCenter.default.removeObserver(self)
    }

    @IBAction func enableButtonPressed(_ sender: UIButton) {
        LocationManager.shared.requestLocationPermissions()
    }

    @objc func checkPermissions() {
        if LocationManager.shared.locationServicesEnabled() == true {
            if Reachability.isConnectedToNetwork() {
                LocationManager.shared.getCurrentLocation()
                self.rootDashboardViewController()
            } else {
                LocationManager.shared.fetchLocalLocation { (location) in
                    LocationManager.shared.rootBasedOnBlockedlocation()
                    self.rootDashboardViewController()
                }
            }
        }
    }

    @objc func locationPermissionsChanged(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo as? [String: CLAuthorizationStatus], let status = userInfo["status"] else {
            return
        }

        if status == .authorizedWhenInUse || status == .authorizedAlways {
            if Reachability.isConnectedToNetwork() {
                LocationManager.shared.getCurrentLocation()
            } else {
                LocationManager.shared.fetchLocalLocation { (location) in }
            }
            
            self.rootDashboardViewController()
        } else {
            self.setupPermissionDeniedUI()
        }
    }
}
