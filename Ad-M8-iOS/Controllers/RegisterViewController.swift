//
//  RegisterViewController.swift
//  Ad-M8-iOS
//
//  Created by James Shaw on 09/10/2017.
//  Copyright © 2017 The Distance. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

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

    class func instantiateFromStoryboard() -> RegisterViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Register"
        self.scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 730.0)
    }

    @IBAction func registerButtonPressed(sender: UIButton) {
        guard let firstName = self.firstNameTextField.text, !firstName.isEmpty else { return }
        guard let lastName = self.lastNameTextField.text, !lastName.isEmpty else { return }
        guard let email = self.emailTextField.text, !email.isEmpty else { return }
        guard let password = self.passwordTextField.text, !password.isEmpty else { return }
        guard let location = self.locationTextField.text, !location.isEmpty else { return }
        guard let dob = self.dobTextField.text, !dob.isEmpty else { return }
        guard let gender = self.genderTextField.text, !gender.isEmpty else { return }
        guard let invitationCode = self.invitationCodeTextField.text, !invitationCode.isEmpty else { return }
        guard self.termsAndConditionsSwitch.isOn == true else { return }

        
    }
}
