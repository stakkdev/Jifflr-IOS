//
//  LocationRequiredViewController.swift
//  Ad-M8-iOS
//
//  Created by James Shaw on 10/10/2017.
//  Copyright © 2017 The Distance. All rights reserved.
//

import UIKit
import CoreLocation

class LocationRequiredViewController: UIViewController, DisplayMessage {

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var enableButton: UIButton!

    class func instantiateFromStoryboard() -> LocationRequiredViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "LocationRequiredViewController") as! LocationRequiredViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationBar.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        NotificationCenter.default.addObserver(self, selector: #selector(locationPermissionsChanged(_:)), name: Constants.Notifications.locationPermissionsChanged, object: nil)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        NotificationCenter.default.removeObserver(self, name: Constants.Notifications.locationPermissionsChanged, object: nil)
    }

    @IBAction func enableButtonPressed(_ sender: UIButton) {
        LocationManager.shared.requestLocationPermissions()
    }

    @objc func locationPermissionsChanged(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo as? [String: CLAuthorizationStatus],
            let status = userInfo["status"] else {
                return
        }

        if status == .authorizedWhenInUse || status == .authorizedAlways {
            self.dismiss(animated: true, completion: {
                self.rootDashboardViewController()
            })
        }
    }
}

extension LocationRequiredViewController: UINavigationBarDelegate {

    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}
