//
//  RegisterViewController.swift
//  Ad-M8-iOS
//
//  Created by James Shaw on 09/10/2017.
//  Copyright © 2017 The Distance. All rights reserved.
//

import UIKit
import Localize_Swift

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
    @IBOutlet weak var invitationCodeTextField: JifflrTextField!
    @IBOutlet weak var termsAndConditionsHeadingButton: UIButton!
    @IBOutlet weak var termsAndConditionsSwitch: UISwitch!
    @IBOutlet weak var registerButton: JifflrButton!

    let genders = Constants.RegistrationGenders
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
        guard let firstName = self.firstNameTextField.text, !firstName.isEmpty else { return }
        guard let lastName = self.lastNameTextField.text, !lastName.isEmpty else { return }
        guard let email = self.emailTextField.text, !email.isEmpty else { return }
        guard let password = self.passwordTextField.text, !password.isEmpty else { return }
        guard let location = self.locationTextField.text, !location.isEmpty else { return }
        guard let dob = self.dobTextField.text, !dob.isEmpty else { return }
        guard let gender = self.genderTextField.text, !gender.isEmpty else { return }
        guard self.termsAndConditionsSwitch.isOn == true else { return }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        guard let dateOfBirth = dateFormatter.date(from: dob) else { return }

        var userInfo = [AnyHashable: Any]()
        userInfo["firstName"] = firstName
        userInfo["lastName"] = lastName
        userInfo["email"] = email
        userInfo["password"] = password
        userInfo["location"] = location
        userInfo["dateOfBirth"] = dateOfBirth
        userInfo["gender"] = gender

        if let invitationCodeString = self.invitationCodeTextField.text, !invitationCodeString.isEmpty {
            if let invitationCode = Int(invitationCodeString) {
                userInfo["invitationCode"] = invitationCode
            }
        }

        UserManager.shared.signUp(withUserInfo: userInfo) { (error) in
            guard error == nil else {
                self.displayMessage(title: error!.failureTitle, message: error!.failureDescription)
                return
            }

            if LocationManager.shared.locationServicesEnabled() == true {
                self.rootDashboardViewController()
            } else {
                let locationRequiredViewController = LocationRequiredViewController.instantiateFromStoryboard()
                self.navigationController?.present(locationRequiredViewController, animated: true, completion: nil)
            }
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
        self.datePicker.date = Date()
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
}

extension RegisterViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let point = textField.frame.origin
        if point.y > self.scrollView.frame.height - 300.0 {
            self.scrollView.contentOffset = point
            self.scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 900.0)
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        self.scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 900.0)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension RegisterViewController: LocationTextFieldDelegate {
    func gpsPressed() {
        LocationManager.shared.getCurrentLocation()
    }

    @objc func locationFound(_ notification: NSNotification) {
        self.locationTextField.stopAnimating()
        
        guard let userInfo = notification.userInfo as? [String: String], let locationAddress = userInfo["location"] else {
            self.displayMessage(title: ErrorMessage.locationFailed.failureTitle, message: ErrorMessage.locationFailed.failureDescription)
            return
        }

        self.locationTextField.text = locationAddress
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
        return self.genders[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.genderTextField.text = self.genders[row]
    }
}
