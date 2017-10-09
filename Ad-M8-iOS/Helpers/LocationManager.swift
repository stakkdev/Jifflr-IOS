//
//  LocationManager.swift
//  Ad-M8-iOS
//
//  Created by James Shaw on 09/10/2017.
//  Copyright © 2017 The Distance. All rights reserved.
//

import UIKit
import CoreLocation

class LocationManager: NSObject {
    static let shared = LocationManager()

    let locationManager = CLLocationManager()
    let geocoder = CLGeocoder()

    func getCurrentLocation() {
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locationManager.stopUpdatingLocation()

        guard locations.count > 0 else {
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: Constants.Notifications.locationFound, object: self, userInfo: nil)
            }
            return
        }

        let location = locations.first!
        self.geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            guard let placemarks = placemarks, placemarks.count > 0, error == nil else {
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: Constants.Notifications.locationFound, object: self, userInfo: nil)
                }
                return
            }

            let placemark = placemarks.first!
            var addressString = ""
            if let city = placemark.subAdministrativeArea {
                addressString = city

                if let country = placemark.country {
                    addressString.append(", \(country)")
                }
            } else if let country = placemark.country {
                addressString = country
            }

            DispatchQueue.main.async {
                var notificationDict:[String: String] = [:]
                notificationDict["location"] = addressString
                NotificationCenter.default.post(name: Constants.Notifications.locationFound, object: self, userInfo: notificationDict)
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: Constants.Notifications.locationFound, object: self, userInfo: nil)
        }
    }
}
