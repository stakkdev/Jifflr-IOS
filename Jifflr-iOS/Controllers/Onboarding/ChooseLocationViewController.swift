//
//  ChooseLocationViewController.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 16/02/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit
import CoreLocation

protocol ChooseLocationViewControllerDelegate: class {
    func locationChosen(displayLocation: String, isoCountryCode: String, coordinate: CLLocationCoordinate2D)
}

class ChooseLocationViewController: BaseViewController {

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var tableView: UITableView!

    var searchString: String!
    var placemarks: [CLPlacemark] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }

    weak var delegate: ChooseLocationViewControllerDelegate?

    class func instantiateFromStoryboard() -> ChooseLocationViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "ChooseLocationViewController") as! ChooseLocationViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.geocode()
    }

    func setupUI() {
        self.setupLocalization()

        self.setBackgroundImage(image: UIImage(named: "MainBackground"))

        self.navigationBar.delegate = self
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = true
        let font = UIFont(name: Constants.FontNames.GothamBold, size: 18.0)!
        self.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: font, NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationBar.tintColor = UIColor.white

        let dismissBarButton = UIBarButtonItem(image: UIImage(named: "NavigationDismiss"), style: .plain, target: self, action: #selector(self.dismissButtonPressed(sender:)))
        self.navigationBar.topItem?.rightBarButtonItem = dismissBarButton

        self.tableView.dataSource = self
        self.tableView.delegate = self

        self.searchBar.text = self.searchString
        self.searchBar.delegate = self
        self.searchBar.addPaddingLeftIcon(image: UIImage(named: "LocationSearch")!, padding: 12.0)
    }

    func setupLocalization() {
        self.navigationBar.topItem?.title = "yourLocation.navigation.title".localized()
    }

    @objc func dismissButtonPressed(sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

    func geocode() {
        guard let text = self.searchBar.text, !text.isEmpty else { return }

        LocationManager.shared.geocode(address: text) { (placemarks) in
            print("Found \(placemarks.count) Placemarks.")
            self.placemarks = placemarks
        }
    }
}

extension ChooseLocationViewController: UINavigationBarDelegate {
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}

extension ChooseLocationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(false)
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        self.searchString = searchBar.text
        self.geocode()
    }
}

extension ChooseLocationViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.placemarks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath)
        cell.textLabel?.text = self.placemarks[indexPath.row].formattedString()
        return cell
    }
}

extension ChooseLocationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let placemark = self.placemarks[indexPath.row]
        let displayLocation = placemark.formattedString()
        guard let isoCountryCode = placemark.isoCountryCode else { return }
        guard let coordinate = placemark.location?.coordinate else { return }

        self.delegate?.locationChosen(displayLocation: displayLocation, isoCountryCode: isoCountryCode, coordinate: coordinate)
        self.dismiss(animated: true, completion: nil)
    }
}
