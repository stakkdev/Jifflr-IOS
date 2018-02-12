//
//  LoginViewController.swift
//  Ad-M8-iOS
//
//  Created by James Shaw on 09/10/2017.
//  Copyright © 2017 The Distance. All rights reserved.
//

import UIKit
import Localize_Swift

class LoginViewController: BaseViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: JifflrButton!
    @IBOutlet weak var registerButton: JifflrButton!
    @IBOutlet weak var jifflrLogoTop: NSLayoutConstraint!
    @IBOutlet weak var jifflrLogoBottom: NSLayoutConstraint!
    @IBOutlet weak var jifflrLogoHeight: NSLayoutConstraint!
    @IBOutlet weak var registerButtonBottom: NSLayoutConstraint!
    @IBOutlet weak var emailHeadingLabel: UILabel!
    @IBOutlet weak var passwordHeadingLabel: UILabel!
    @IBOutlet weak var forgotPasswordButton: UIButton!

    class func instantiateFromStoryboard() -> LoginViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
    }

    func setupUI() {
        self.setupLocalization()

        self.setBackgroundImage(image: UIImage(named: "MainBackground"))
        self.loginButton.setBackgroundColor(color: UIColor.mainPink)
        self.registerButton.setBackgroundColor(color: UIColor.mainBlueTransparent80)

        if Constants.isSmallScreen {
            self.jifflrLogoTop.constant = 12.0
            self.jifflrLogoBottom.constant = 22.0
            self.jifflrLogoHeight.constant = 42.0
            self.registerButtonBottom.constant = 30.0
        }
    }

    func setupLocalization() {
        self.title = "login.navigation.title".localized()
        self.loginButton.setTitle("login.loginButton.title".localized(), for: .normal)
        self.registerButton.setTitle("login.registerButton.title".localized(), for: .normal)
        self.forgotPasswordButton.setTitle("login.forgotPasswordButton.title".localized(), for: .normal)
        self.emailHeadingLabel.text = "login.email.heading".localized()
        self.passwordHeadingLabel.text = "login.password.heading".localized()
        self.emailTextField.placeholder = "login.email.placeholder".localized()
        self.passwordTextField.placeholder = "login.password.placeholder".localized()
    }

    @IBAction func loginButtonPressed(sender: UIButton) {
        guard let email = self.emailTextField.text, !email.isEmpty else {
            self.displayMessage(title: ErrorMessage.loginFailed.failureTitle, message: ErrorMessage.loginFailed.failureDescription)
            return
        }

        guard let password = self.passwordTextField.text, !password.isEmpty else {
            self.displayMessage(title: ErrorMessage.loginFailed.failureTitle, message: ErrorMessage.loginFailed.failureDescription)
            return
        }

        self.loginButton.animate()

        UserManager.shared.login(withUsername: email, password: password) { (_, error) in
            self.loginButton.stopAnimating()
            
            guard error == nil else {
                self.displayMessage(title: error!.failureTitle, message: error!.failureDescription)
                return
            }

            if LocationManager.shared.locationServicesEnabled() == true {
                self.rootDashboardViewController()
            } else {
                let locationRequiredViewController = LocationRequiredViewController.instantiateFromStoryboard()
                self.navigationController?.pushViewController(locationRequiredViewController, animated: true)
            }
        }
    }

    @IBAction func registerButtonPressed(sender: UIButton) {
        let registerViewController = RegisterViewController.instantiateFromStoryboard()
        self.navigationController?.pushViewController(registerViewController, animated: true)
    }

    @IBAction func forgotPasswordPressed(sender: UIButton) {
        let forgotPasswordViewController = ForgotPasswordViewController.instantiateFromStoryboard()
        self.navigationController?.pushViewController(forgotPasswordViewController, animated: true)
    }
}

