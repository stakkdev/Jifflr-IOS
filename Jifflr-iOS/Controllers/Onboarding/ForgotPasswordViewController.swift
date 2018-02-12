//
//  ForgotPasswordViewController.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 12/02/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: BaseViewController {

    @IBOutlet weak var passwordResetButton: JifflrButton!
    @IBOutlet weak var emailHeadingLabel: UILabel!
    @IBOutlet weak var emailTextField: JifflrTextField!

    class func instantiateFromStoryboard() -> ForgotPasswordViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
    }

    func setupUI() {
        self.setupLocalization()

        self.setBackgroundImage(image: UIImage(named: "MainBackground"))
        self.passwordResetButton.setBackgroundColor(color: UIColor.mainPink)
    }

    func setupLocalization() {
        self.title = "forgotPassword.navigation.title".localized()
        self.passwordResetButton.setTitle("forgotPassword.button.title".localized(), for: .normal)
        self.emailHeadingLabel.text = "forgotPassword.email.heading".localized()
        self.emailTextField.placeholder = "forgotPassword.email.placeholder".localized()
    }

    @IBAction func resetPassword(sender: UIButton) {

        guard let email = self.emailTextField.text, !email.isEmpty else {
            self.displayMessage(title: ErrorMessage.resetPasswordFailed.failureTitle, message: ErrorMessage.resetPasswordFailed.failureDescription)
            return
        }

        UserManager.shared.resetPassword(email: email) { (error) in
            if error != nil {
                self.displayMessage(title: error!.failureTitle, message: error!.failureDescription)
            } else {
                self.displayMessage(title: AlertMessage.resetEmailSent.title, message: AlertMessage.resetEmailSent.message)
            }
        }
    }
}
