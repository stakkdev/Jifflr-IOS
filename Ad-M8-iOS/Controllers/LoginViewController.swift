//
//  LoginViewController.swift
//  Ad-M8-iOS
//
//  Created by James Shaw on 09/10/2017.
//  Copyright © 2017 The Distance. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

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

        self.title = "Login"
    }

    @IBAction func loginButtonPressed(sender: UIButton) {
        guard let email = self.emailTextField.text, !email.isEmpty else { return }
        guard let password = self.passwordTextField.text, !password.isEmpty else { return }
    }

    @IBAction func registerButtonPressed(sender: UIButton) {
        let registerViewController = RegisterViewController.instantiateFromStoryboard()
        self.navigationController?.pushViewController(registerViewController, animated: true)
    }
}

