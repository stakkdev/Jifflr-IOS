//
//  RegisterViewController.swift
//  Ad-M8-iOS
//
//  Created by James Shaw on 09/10/2017.
//  Copyright © 2017 The Distance. All rights reserved.
//

import UIKit
import Localize_Swift
import CoreLocation
import Parse

class RegisterViewController: BaseViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var firstNameHeadingLabel: UILabel!
    @IBOutlet weak var firstNameTextField: JifflrTextField!
    @IBOutlet weak var lastNameHeadingLabel: UILabel!
    @IBOutlet weak var lastNameTextField: JifflrTextField!
    @IBOutlet weak var emailHeadingLabel: UILabel!
    @IBOutlet weak var emailTextField: JifflrTextField!
    @IBOutlet weak var passwordHeadingLabel: UILabel!
    @IBOutlet weak var passwordTextField: JifflrTextFieldPassword!
    @IBOutlet weak var locationHeadingLabel: UILabel!
    @IBOutlet weak var locationTextField: JifflrTextFieldLocation!
    @IBOutlet weak var dobHeadingLabel: UILabel!
    @IBOutlet weak var dobTextField: JifflrTextFieldSelection!
    @IBOutlet weak var genderHeadingLabel: UILabel!
    @IBOutlet weak var genderTextField: JifflrTextFieldSelection!
    @IBOutlet weak var invitationCodeHeadingLabel: UILabel!
    @IBOutlet weak var invitationCodeTextField: JifflrTextFieldInvitation!
    @IBOutlet weak var termsAndConditionsHeadingButton: UIButton!
    @IBOutlet weak var termsAndConditionsSwitch: UISwitch!
    @IBOutlet weak var registerButton: JifflrButton!

    var genders:[Gender] = []
    var genderPickerView: UIPickerView!
    var datePicker: UIDatePicker!

    class func instantiateFromStoryboard() -> RegisterViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
        self.createInputViews()
        self.setupData()
    }

    func setupUI() {
        self.setupLocalization()

        self.scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 900.0)
        self.registerButton.setBackgroundColor(color: UIColor.mainPink)

        self.firstNameTextField.delegate = self
        self.lastNameTextField.delegate = self
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        self.locationTextField.delegate = self
        self.locationTextField.locationDelegate = self
        self.dobTextField.delegate = self
        self.genderTextField.delegate = self
        self.invitationCodeTextField.delegate = self

        self.setBackgroundImage(image: UIImage(named: "MainBackground"))
    }

    func setupLocalization() {
        self.title = "register.navigation.title".localized()
        self.firstNameHeadingLabel.text = "register.firstName.heading".localized()
        self.firstNameTextField.placeholder = "register.firstName.placeholder".localized()
        self.lastNameHeadingLabel.text = "register.lastName.heading".localized()
        self.lastNameTextField.placeholder = "register.lastName.placeholder".localized()
        self.emailHeadingLabel.text = "register.email.heading".localized()
        self.emailTextField.placeholder = "register.email.placeholder".localized()
        self.passwordHeadingLabel.text = "register.password.heading".localized()
        self.passwordTextField.placeholder = "register.password.placeholder".localized()
        self.locationHeadingLabel.text = "register.location.heading".localized()
        self.locationTextField.placeholder = "register.location.placeholder".localized()
        self.dobHeadingLabel.text = "register.dob.heading".localized()
        self.dobTextField.placeholder = "register.dob.placeholder".localized()
        self.genderHeadingLabel.text = "register.gender.heading".localized()
        self.genderTextField.placeholder = "register.gender.placeholder".localized()
        self.invitationCodeHeadingLabel.text = "register.invitationCode.heading".localized()
        self.invitationCodeTextField.placeholder = "register.invitationCode.placeholder".localized()
        self.registerButton.setTitle("register.registerButton.title".localized(), for: .normal)

        let font = UIFont(name: Constants.FontNames.GothamBold, size: 12.0)!
        let attributes = [NSAttributedStringKey.font: font,
             NSAttributedStringKey.foregroundColor: UIColor.white,
             NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue
        ] as [NSAttributedStringKey: Any]
        let attributedText = NSAttributedString(string: "register.termsAndConditions.heading".localized(), attributes: attributes)
        self.termsAndConditionsHeadingButton.setAttributedTitle(attributedText, for: .normal)
    }
    
    func setupData() {
        UserManager.shared.fetchGenders { (genders) in
            guard genders.count > 0 else {
                return
            }
            
            self.genders = genders
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        NotificationCenter.default.addObserver(self, selector: #selector(locationFound(_:)), name: Constants.Notifications.locationFound, object: nil)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        NotificationCenter.default.removeObserver(self, name: Constants.Notifications.locationFound, object: nil)
    }

    @IBAction func termsAndConditionsPressed(sender: UIButton) {
        let termsAndConditions = TermsAndConditionsViewController.instantiateFromStoryboard()
        self.navigationController?.present(termsAndConditions, animated: true, completion: nil)
    }

    @IBAction func registerButtonPressed(sender: UIButton) {
        guard Reachability.isConnectedToNetwork() else {
            self.displayError(error: ErrorMessage.NoInternetConnectionRegistration)
            return
        }
        
        guard let firstName = self.firstNameTextField.text, !firstName.isEmpty, !firstName.containsNumbers() else {
            let error = ErrorMessage.invalidField("register.firstName.heading".localized())
            self.displayMessage(title: error.failureTitle, message: error.failureDescription)
            return
        }

        guard let lastName = self.lastNameTextField.text, !lastName.isEmpty, !lastName.containsNumbers() else {
            let error = ErrorMessage.invalidField("register.lastName.heading".localized())
            self.displayMessage(title: error.failureTitle, message: error.failureDescription)
            return
        }

        guard let email = self.emailTextField.text, !email.isEmpty, email.isEmail() else {
            let error = ErrorMessage.invalidField("register.email.heading".localized())
            self.displayMessage(title: error.failureTitle, message: error.failureDescription)
            return
        }

        guard let password = self.passwordTextField.text, !password.isEmpty, password.count >= 8 else {
            let error = ErrorMessage.invalidPassword
            self.displayMessage(title: error.failureTitle, message: error.failureDescription)
            return
        }
        
        guard let displayLocation = self.locationTextField.text, !displayLocation.isEmpty,
            let location = self.locationTextField.location,
            let geoPoint = self.locationTextField.geoPoint else {
            let error = ErrorMessage.invalidField("register.location.heading".localized())
            self.displayMessage(title: error.failureTitle, message: error.failureDescription)
            return
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        guard let dob = self.dobTextField.text, !dob.isEmpty, let dateOfBirth = dateFormatter.date(from: dob) else {
            let error = ErrorMessage.invalidField("register.dob.heading".localized())
            self.displayMessage(title: error.failureTitle, message: error.failureDescription)
            return
        }

        guard let minimumDate = Calendar.current.date(byAdding: .year, value: -18, to: Date()), minimumDate > dateOfBirth else {
            let error = ErrorMessage.invalidDob
            self.displayMessage(title: error.failureTitle, message: error.failureDescription)
            return
        }

        guard let genderName = self.genderTextField.text, !genderName.isEmpty,
            let gender = self.genders.first(where: { $0.name == genderName }) else {
            let error = ErrorMessage.invalidGender
            self.displayMessage(title: error.failureTitle, message: error.failureDescription)
            return
        }

        guard self.termsAndConditionsSwitch.isOn == true else {
            let error = ErrorMessage.invalidTermsAndConditions
            self.displayMessage(title: error.failureTitle, message: error.failureDescription)
            return
        }

        self.registerButton.animate()

        var userInfo = [AnyHashable: Any]()
        userInfo["firstName"] = firstName
        userInfo["lastName"] = lastName
        userInfo["email"] = email.lowercased()
        userInfo["password"] = password
        userInfo["displayLocation"] = displayLocation
        userInfo["location"] = location
        userInfo["geoPoint"] = geoPoint
        userInfo["dateOfBirth"] = dateOfBirth
        userInfo["gender"] = gender

        if let invitationCode = self.invitationCodeTextField.text, !invitationCode.isEmpty {
            userInfo["invitationCode"] = invitationCode
        }
        
        LanguageManager.shared.fetchLanguage(languageCode: Session.shared.currentLanguage, pinName: nil) { (language) in
            guard let language = language else { return }
            userInfo["language"] = language
            
            UserManager.shared.signUp(withUserInfo: userInfo) { (error) in
                self.registerButton.stopAnimating()
                
                guard error == nil else {
                    if error!.failureDescription == ErrorMessage.invalidInvitationCodeRegistration.failureDescription {
                        let dismissText = "error.invalidInvitationCodeRegistration.dismiss".localized()
                        self.displayMessage(title: error!.failureTitle, message: error!.failureDescription, dismissText: dismissText, dismissAction: { (action) in
                            self.rootAfterRegistration()
                            return
                        })
                    } else {
                        self.displayError(error: error)
                    }
                    return
                }
                
                self.rootAfterRegistration()
            }
        }
    }

    func rootAfterRegistration() {
        if LocationManager.shared.locationServicesEnabled() == true && Session.shared.currentLocation != nil {
            self.rootDashboardViewController()
        } else {
            let locationRequiredViewController = LocationRequiredViewController.instantiateFromStoryboard()
            self.navigationController?.present(locationRequiredViewController, animated: true, completion: nil)
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
        let flexibleSpacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.items = [flexibleSpacer, closeButton]
        self.genderTextField.inputAccessoryView = toolbar

        self.datePicker = UIDatePicker()
        self.datePicker.date = Date()
        self.datePicker.datePickerMode = .date
        self.datePicker.maximumDate = Date()
        self.datePicker.addTarget(self, action: #selector(datePicked), for: .valueChanged)
        self.dobTextField.inputView = self.datePicker

        let dateToolbar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: 44.0))
        dateToolbar.barStyle = UIBarStyle.default
        let dateCloseButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.dateCloseButtonPressed))
        dateToolbar.items = [flexibleSpacer, dateCloseButton]
        self.dobTextField.inputAccessoryView = dateToolbar
    }

    @objc func pickerCloseButtonPressed() {
        guard self.genders.count > 0 else { return }
        let selectedIndex = self.genderPickerView.selectedRow(inComponent: 0)
        self.genderTextField.text = self.genders[selectedIndex].name
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
}

extension RegisterViewController: UITextFieldDelegate {

    func textFieldDidEndEditing(_ textField: UITextField) {
        if let email = textField.text, !email.isEmpty, textField == self.emailTextField {
            self.invitationCodeTextField.animate()

            PendingUserManager.shared.fetchInvitationCode(email: email, completion: { (invitationCode) in
                self.invitationCodeTextField.stopAnimating()

                guard let invitationCode = invitationCode else { return }
                self.invitationCodeTextField.text = invitationCode
            })
        }

        if textField == self.locationTextField, let text = textField.text, !text.isEmpty {
            self.locationTextField.animate()

            let chooseLocation = ChooseLocationViewController.instantiateFromStoryboard()
            chooseLocation.searchString = text
            chooseLocation.delegate = self
            self.present(chooseLocation, animated: true) {
                self.view.endEditing(true)
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.firstNameTextField || textField == self.lastNameTextField {
            if string.count > 0 {
                var allowedCharacters = CharacterSet.letters
                allowedCharacters.insert(charactersIn: " -")
                
                let unwantedStr = string.trimmingCharacters(in: allowedCharacters)
                return unwantedStr.count == 0
            }
            
            return true
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.genderTextField, genders.count == 0 {
            self.displayError(error: ErrorMessage.genderFetchFailed)
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension RegisterViewController: ChooseLocationViewControllerDelegate {
    func locationChosen(displayLocation: String, isoCountryCode: String, coordinate: CLLocationCoordinate2D) {
        self.fetchLocation(displayLocation: displayLocation, isoCountryCode: isoCountryCode, coordinate: coordinate)
    }

    func dismissed() {
        self.locationTextField.stopAnimating()
    }

    func fetchLocation(displayLocation: String, isoCountryCode: String, coordinate: CLLocationCoordinate2D) {
        guard Reachability.isConnectedToNetwork() else {
            self.displayError(error: ErrorMessage.locationFailed)
            return
        }
        
        LocationManager.shared.fetchLocation(isoCountryCode: isoCountryCode) { (location, error) in
            self.locationTextField.stopAnimating()

            guard let location = location, error == nil else {
                let error = ErrorMessage.blockedCountry
                self.displayMessage(title: error.failureTitle, message: error.failureDescription, dismissText: nil, dismissAction: { (action) in
                    self.navigationController?.popViewController(animated: true)
                })
                return
            }

            self.locationTextField.text = displayLocation
            self.locationTextField.geoPoint = PFGeoPoint(latitude: coordinate.latitude, longitude: coordinate.longitude)
            self.locationTextField.location = location
        }
    }
}

extension RegisterViewController: LocationTextFieldDelegate {
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

extension RegisterViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.genders.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.genders[row].name
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.genderTextField.text = self.genders[row].name
    }
}
