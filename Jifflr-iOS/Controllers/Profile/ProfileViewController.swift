//
//  ProfileViewController.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 20/02/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit
import CoreLocation
import Parse

class ProfileViewController: BaseViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var firstNameHeadingLabel: UILabel!
    @IBOutlet weak var firstNameTextField: JifflrTextField!
    @IBOutlet weak var lastNameHeadingLabel: UILabel!
    @IBOutlet weak var lastNameTextField: JifflrTextField!
    @IBOutlet weak var emailHeadingLabel: UILabel!
    @IBOutlet weak var emailTextField: JifflrTextField!
    @IBOutlet weak var locationHeadingLabel: UILabel!
    @IBOutlet weak var locationTextField: JifflrTextFieldLocation!
    @IBOutlet weak var dobHeadingLabel: UILabel!
    @IBOutlet weak var dobTextField: JifflrTextFieldSelection!
    @IBOutlet weak var genderHeadingLabel: UILabel!
    @IBOutlet weak var genderTextField: JifflrTextFieldSelection!
    @IBOutlet weak var invitationCodeHeadingLabel: UILabel!
    @IBOutlet weak var invitationCodeTextField: JifflrTextFieldInvitation!
    @IBOutlet weak var logoutButton: JifflrButton!
    @IBOutlet weak var deleteAccountButton: JifflrButton!
    @IBOutlet weak var changePasswordButton: JifflrButton!
    @IBOutlet weak var changePasswordButtonTop: NSLayoutConstraint!

    let genders = Constants.RegistrationGenders
    var genderPickerView: UIPickerView!
    var datePicker: UIDatePicker!

    class func instantiateFromStoryboard() -> ProfileViewController {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
        self.createInputViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        NotificationCenter.default.addObserver(self, selector: #selector(locationFound(_:)), name: Constants.Notifications.locationFound, object: nil)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        NotificationCenter.default.removeObserver(self, name: Constants.Notifications.locationFound, object: nil)
    }

    func setupUI() {
        self.setupLocalization()
        self.setupData()

        self.setBackgroundImage(image: UIImage(named: "MainBackground"))
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.setHidesBackButton(false, animated: false)

        self.firstNameTextField.delegate = self
        self.lastNameTextField.delegate = self
        self.emailTextField.delegate = self
        self.locationTextField.delegate = self
        self.locationTextField.locationDelegate = self
        self.dobTextField.delegate = self
        self.genderTextField.delegate = self
        self.invitationCodeTextField.delegate = self

        self.scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 900.0)
        self.logoutButton.setBackgroundColor(color: UIColor.mainBlueTransparent80)
        self.deleteAccountButton.setBackgroundColor(color: UIColor.mainBlueTransparent80)
        self.changePasswordButton.setBackgroundColor(color: UIColor.mainPink)

        let settingsBarButton = UIBarButtonItem(image: UIImage(named: "SettingsButton"), style: .plain, target: self, action: #selector(self.settingsButtonPressed))
        self.navigationItem.rightBarButtonItem = settingsBarButton
    }

    func setupLocalization() {
        self.title = "profile.navigation.title".localized()
        self.firstNameHeadingLabel.text = "register.firstName.heading".localized()
        self.firstNameTextField.placeholder = "register.firstName.placeholder".localized()
        self.lastNameHeadingLabel.text = "register.lastName.heading".localized()
        self.lastNameTextField.placeholder = "register.lastName.placeholder".localized()
        self.emailHeadingLabel.text = "register.email.heading".localized()
        self.emailTextField.placeholder = "register.email.placeholder".localized()
        self.locationHeadingLabel.text = "register.location.heading".localized()
        self.locationTextField.placeholder = "register.location.placeholder".localized()
        self.dobHeadingLabel.text = "register.dob.heading".localized()
        self.dobTextField.placeholder = "register.dob.placeholder".localized()
        self.genderHeadingLabel.text = "register.gender.heading".localized()
        self.genderTextField.placeholder = "register.gender.placeholder".localized()
        self.invitationCodeHeadingLabel.text = "register.invitationCode.heading".localized()
        self.invitationCodeTextField.placeholder = "register.invitationCode.placeholder".localized()
        self.deleteAccountButton.setTitle("profile.deleteAccountButton.title".localized(), for: .normal)
        self.logoutButton.setTitle("profile.logoutButton.title".localized(), for: .normal)
        self.changePasswordButton.setTitle("profile.changePasswordButton.title".localized(), for: .normal)
    }

    func setupData() {
        guard let currentUser = Session.shared.currentUser else { return }

        self.firstNameTextField.text = currentUser.details.firstName
        self.lastNameTextField.text = currentUser.details.lastName
        self.emailTextField.text = currentUser.email
        self.locationTextField.text = currentUser.details.displayLocation

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        self.dobTextField.text = dateFormatter.string(from: currentUser.details.dateOfBirth)

        self.genderTextField.text = currentUser.details.gender
        self.invitationCodeTextField.text = currentUser.details.invitationCode

        if let invitationCode = currentUser.details.invitationCode, !invitationCode.isEmpty {
            self.invitationCodeTextField.isHidden = false
            self.invitationCodeHeadingLabel.isHidden = false
            self.changePasswordButtonTop.constant = 117.0
        } else {
            if !currentUser.canEditInvitationCode() {
                self.invitationCodeTextField.isHidden = true
                self.invitationCodeHeadingLabel.isHidden = true
                self.changePasswordButtonTop.constant = 27.0
            }
        }

        if currentUser.canEditInvitationCode() {
            self.invitationCodeTextField.isUserInteractionEnabled = true
            self.invitationCodeTextField.textColor = UIColor.mainBlue
        } else {
            self.invitationCodeTextField.isUserInteractionEnabled = false
            self.invitationCodeTextField.textColor = UIColor.lightGray
        }
    }

    func createInputViews() {
        self.genderPickerView = UIPickerView()
        self.genderPickerView.delegate = self
        self.genderPickerView.dataSource = self
        self.genderTextField.inputView = self.genderPickerView

        let toolbar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: 44.0))
        toolbar.barStyle = UIBarStyle.default
        let closeButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.pickerCloseButtonPressed))
        toolbar.items = [closeButton]
        self.genderTextField.inputAccessoryView = toolbar

        self.datePicker = UIDatePicker()
        if let currentUser = Session.shared.currentUser {
            self.datePicker.date = currentUser.details.dateOfBirth
        } else {
            self.datePicker.date = Date()
        }
        self.datePicker.datePickerMode = .date
        self.datePicker.maximumDate = Date()
        self.datePicker.addTarget(self, action: #selector(datePicked), for: .valueChanged)
        self.dobTextField.inputView = self.datePicker

        let dateToolbar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: 44.0))
        dateToolbar.barStyle = UIBarStyle.default
        let dateCloseButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.dateCloseButtonPressed))
        dateToolbar.items = [dateCloseButton]
        self.dobTextField.inputAccessoryView = dateToolbar
    }

    @objc func pickerCloseButtonPressed() {
        let selectedIndex = self.genderPickerView.selectedRow(inComponent: 0)
        self.genderTextField.text = self.genders[selectedIndex]
        self.genderTextField.resignFirstResponder()
    }

    @objc func datePicked(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        self.dobTextField.text = dateFormatter.string(from: sender.date)
    }

    @objc func dateCloseButtonPressed() {
        self.datePicked(sender: self.datePicker)
        self.dobTextField.resignFirstResponder()
    }

    @objc func settingsButtonPressed() {
        self.navigationController?.pushViewController(SettingsViewController.instantiateFromStoryboard(), animated: true)
    }

    @IBAction func logoutButtonPressed(sender: UIButton) {
        UserManager.shared.logOut { (error) in
            guard error == nil else {
                self.displayMessage(title: error!.failureTitle, message: error!.failureDescription)
                return
            }

            self.rootLoginViewController()
        }
    }

    @IBAction func deleteAccountButtonPressed(sender: UIButton) {

    }

    @IBAction func changePasswordButtonPressed(sender: UIButton) {
        self.navigationController?.pushViewController(ChangePasswordViewController.instantiateFromStoryboard(), animated: true)
    }
}

extension ProfileViewController: UITextFieldDelegate {

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.locationTextField, let text = textField.text, !text.isEmpty {
            self.locationTextField.animate()

            let chooseLocation = ChooseLocationViewController.instantiateFromStoryboard()
            chooseLocation.searchString = text
            chooseLocation.delegate = self
            self.present(chooseLocation, animated: true, completion: nil)
        } else {
            self.validateField(textField: textField)
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension ProfileViewController: ChooseLocationViewControllerDelegate {
    func locationChosen(displayLocation: String, isoCountryCode: String, coordinate: CLLocationCoordinate2D) {
        self.fetchLocation(displayLocation: displayLocation, isoCountryCode: isoCountryCode, coordinate: coordinate)
    }

    func dismissed() {
        self.locationTextField.stopAnimating()
    }

    func fetchLocation(displayLocation: String, isoCountryCode: String, coordinate: CLLocationCoordinate2D) {
        LocationManager.shared.fetchLocation(isoCountryCode: isoCountryCode) { (location, error) in
            self.locationTextField.stopAnimating()

            guard let location = location, error == nil else {
                self.displayMessage(title: ErrorMessage.locationFailed.failureTitle, message: ErrorMessage.locationFailed.failureDescription)
                return
            }

            self.locationTextField.text = displayLocation
            self.locationTextField.geoPoint = PFGeoPoint(latitude: coordinate.latitude, longitude: coordinate.longitude)
            self.locationTextField.location = location

            self.validateField(textField: self.locationTextField)
        }
    }
}

extension ProfileViewController: LocationTextFieldDelegate {
    func gpsPressed() {
        LocationManager.shared.getCurrentLocation()
    }

    @objc func locationFound(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo as? [String: Any],
            let displayLocation = userInfo["location"] as? String,
            let isoCountryCode = userInfo["isoCountryCode"] as? String,
            let coordinate = userInfo["geoPoint"] as? CLLocationCoordinate2D else {
                self.locationTextField.stopAnimating()
                self.displayMessage(title: ErrorMessage.locationFailed.failureTitle, message: ErrorMessage.locationFailed.failureDescription)
                return
        }

        self.fetchLocation(displayLocation: displayLocation, isoCountryCode: isoCountryCode, coordinate: coordinate)
    }
}

extension ProfileViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.genders.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.genders[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.genderTextField.text = self.genders[row]
    }
}
