//
//  RegisterViewController.swift
//  Ad-M8-iOS
//
//  Created by James Shaw on 09/10/2017.
//  Copyright © 2017 The Distance. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, DisplayMessage {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var dobTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var invitationCodeTextField: UITextField!
    @IBOutlet weak var termsAndConditionsSwitch: UISwitch!
    @IBOutlet weak var registerButton: UIButton!

    let genders = ["Male", "Female"]
    var genderPickerView: UIPickerView!
    var datePicker: UIDatePicker!

    class func instantiateFromStoryboard() -> RegisterViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Register"
        self.scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 730.0)

        self.firstNameTextField.delegate = self
        self.lastNameTextField.delegate = self
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        self.locationTextField.delegate = self
        self.dobTextField.delegate = self
        self.genderTextField.delegate = self
        self.invitationCodeTextField.delegate = self

        self.createInputViews()
    }

    @IBAction func registerButtonPressed(sender: UIButton) {
        guard let firstName = self.firstNameTextField.text, !firstName.isEmpty else { return }
        guard let lastName = self.lastNameTextField.text, !lastName.isEmpty else { return }
        guard let email = self.emailTextField.text, !email.isEmpty else { return }
        guard let password = self.passwordTextField.text, !password.isEmpty else { return }
        guard let location = self.locationTextField.text, !location.isEmpty else { return }
        guard let dob = self.dobTextField.text, !dob.isEmpty else { return }
        guard let gender = self.genderTextField.text, !gender.isEmpty else { return }
        guard let invitationCodeString = self.invitationCodeTextField.text, !invitationCodeString.isEmpty else { return }
        guard let invitationCode = Int(invitationCodeString) else { return }
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
        userInfo["invitationCode"] = invitationCode

        UserManager.shared.signUp(withUserInfo: userInfo) { (error) in
            guard error == nil else {
                self.displayMessage(title: error!.failureTitle, message: error!.failureDescription)
                return
            }

            print("Signed Up")
        }
    }

    func createInputViews() {
        self.genderPickerView = UIPickerView()
        self.genderPickerView.delegate = self
        self.genderPickerView.dataSource = self
        self.genderPickerView.backgroundColor = UIColor.lightGray
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
        self.scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 730.0)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
