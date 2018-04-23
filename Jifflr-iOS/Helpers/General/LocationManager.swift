//
//  LocationManager.swift
//  Ad-M8-iOS
//
//  Created by James Shaw on 09/10/2017.
//  Copyright © 2017 The Distance. All rights reserved.
//

import UIKit
import CoreLocation
import Parse

class LocationManager: NSObject {
    static let shared = LocationManager()
    
    let pinName = "Location"

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
    
    func fetchLocations(completion: @escaping ([Location]) -> Void) {
        let query = Location.query()
        query?.order(byAscending: "name")
        query?.findObjectsInBackground(block: { (objects, error) in
            guard let locations = objects as? [Location], error == nil else {
                completion([])
                return
            }
            
            completion(locations)
        })
    }
    
    func fetchLocalLocation() {
        let query = Location.query()
        query?.fromPin(withName: self.pinName)
        query?.includeKey("locationStatus")
        query?.getFirstObjectInBackground(block: { (location, error) in
            guard let location = location as? Location, error == nil else {
                self.rootBasedOnLocation(location: nil)
                return
            }
            
            self.rootBasedOnLocation(location: location)
        })
    }

    func fetchLocation(isoCountryCode: String, completion: @escaping (Location?, ErrorMessage?) -> Void) {
        let query = Location.query()
        query?.whereKey("isoCountryCode", equalTo: isoCountryCode)
        query?.includeKey("locationStatus")
        query?.getFirstObjectInBackground(block: { (country, error) in
            guard let country = country as? Location, error == nil else {
                completion(nil, ErrorMessage.blockedCountry)
                return
            }
            
            PFObject.unpinAllObjectsInBackground(withName: self.pinName, block: { (success, error) in
                country.pinInBackground(withName: self.pinName, block: { (success, error) in
                    country.locationStatus.pinInBackground(withName: self.pinName, block: { (success, error) in
                        print("Country Pinned: \(success)")
                    })
                })
            })
            
            completion(country, nil)
        })
    }
    
    func handleLocation(isoCountryCode: String?) {
        guard let isoCountryCode = isoCountryCode else {
            self.rootBasedOnLocation(location: nil)
            return
        }
        
        self.fetchLocation(isoCountryCode: isoCountryCode) { (location, error) in
            guard let location = location, error == nil else {
                self.rootBasedOnLocation(location: nil)
                return
            }
            
            self.rootBasedOnLocation(location: location)
        }
    }
    
    func rootBasedOnLocation(location: Location?) {
        guard let location = location else {
            self.rootBasedOnBlockedlocation()
            return
        }
        
        Session.shared.currentLocation = location
        print("HIT")
        
        switch location.locationStatus.type {
        case LocationStatusType.Active:
            print("Location (\(location.name)) is active.")
            return
        case LocationStatusType.Disabled:
            self.rootBasedOnBlockedlocation()
        case LocationStatusType.AllowCashOut:
            print("Location (\(location.name)) allows cash out.")
            return
        default:
            return
        }
    }
    
    func rootBasedOnBlockedlocation() {
        UserManager.shared.logOut(completion: { (error) in
            guard let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController else { return }
            
            if let _ = navController.viewControllers.first as? LoginViewController {
                // Already on Login Screen
            } else {
                navController.rootLoginViewController()
            }
            
            if let newRootViewController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
                if let visibleViewController = newRootViewController.visibleViewController as? BaseViewController {
                    visibleViewController.displayError(error: ErrorMessage.blockedCountry)
                }
            }
        })
    }
    
    func canViewAdverts() -> Bool {
        guard let location = Session.shared.currentLocation else {
            return false
        }
        
        guard location.locationStatus.type == LocationStatusType.Active else {
            return false
        }
        
        return true
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locationManager.stopUpdatingLocation()

        guard locations.count > 0 else {
            self.handleLocation(isoCountryCode: nil)
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: Constants.Notifications.locationFound, object: self, userInfo: nil)
            }
            return
        }

        let location = locations.first!
        self.geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            guard let placemark = placemarks?.first, error == nil else {
                self.handleLocation(isoCountryCode: nil)
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: Constants.Notifications.locationFound, object: self, userInfo: nil)
                }
                return
            }

            let addressString = placemark.formattedString()
            
            self.handleLocation(isoCountryCode: placemark.isoCountryCode)

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

        if let city = self.locality {
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
