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

    func requestLocationPermissions() {
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
    }

    func locationServicesEnabled() -> Bool {
        if CLLocationManager.locationServicesEnabled() {
            switch (CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                return false
            case .authorizedAlways, .authorizedWhenInUse:
                return true
            }
        }

        return false
    }

    func geocode(address: String, completion: @escaping ([CLPlacemark]) -> Void) {
        self.geocoder.geocodeAddressString(address, completionHandler: { (placemarks, error) -> Void in
            guard error == nil, let placemarks = placemarks else {
                completion([])
                return
            }

            completion(placemarks)
        })
    }

    func fetchLocation(isoCountryCode: String, completion: @escaping (Location?, ErrorMessage?) -> Void) {
        let query = Location.query()
        query?.whereKey("isoCountryCode", equalTo: isoCountryCode)
        query?.getFirstObjectInBackground(block: { (country, error) in
            guard let country = country as? Location, error == nil else {
                return
            }

            completion(country, nil)
        })
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
            guard let placemark = placemarks?.first, error == nil else {
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: Constants.Notifications.locationFound, object: self, userInfo: nil)
                }
                return
            }

            let addressString = placemark.formattedString()

            DispatchQueue.main.async {
                var notificationDict:[String: Any] = [:]
                notificationDict["location"] = addressString
                notificationDict["isoCountryCode"] = placemark.isoCountryCode
                notificationDict["geoPoint"] = placemark.location?.coordinate
                NotificationCenter.default.post(name: Constants.Notifications.locationFound, object: self, userInfo: notificationDict)
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: Constants.Notifications.locationFound, object: self, userInfo: nil)
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        DispatchQueue.main.async {
            UserDefaultsManager.shared.setLocationPermissionsRequested()

            var notificationDict:[String: CLAuthorizationStatus] = [:]
            notificationDict["status"] = status
            NotificationCenter.default.post(name: Constants.Notifications.locationPermissionsChanged, object: self, userInfo: notificationDict)
        }
    }
}

extension CLPlacemark {
    func formattedString() -> String {
        var addressString = ""

        if let city = self.subAdministrativeArea {
            addressString = city

            if let country = self.country {
                addressString.append(", \(country)")
            }
        } else if let country = self.country {
            addressString = country
        }

        return addressString
    }
}
