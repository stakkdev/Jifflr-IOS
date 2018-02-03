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
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!

    class func instantiateFromStoryboard() -> LoginViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "login.navigation.title".localized()
    }

    @IBAction func loginButtonPressed(sender: UIButton) {
        guard let email = self.emailTextField.text, !email.isEmpty else { return }
        guard let password = self.passwordTextField.text, !password.isEmpty else { return }

        UserManager.shared.login(withUsername: email, password: password) { (_, error) in
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

    @IBAction func registerButtonPressed(sender: UIButton) {
        let registerViewController = RegisterViewController.instantiateFromStoryboard()
        self.navigationController?.pushViewController(registerViewController, animated: true)
    }
}

