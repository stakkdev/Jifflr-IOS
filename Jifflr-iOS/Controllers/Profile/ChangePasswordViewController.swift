//
//  ChangePasswordViewController.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 22/02/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit

class ChangePasswordViewController: BaseViewController {

    @IBOutlet weak var currentPasswordHeadingLabel: UILabel!
    @IBOutlet weak var currentPasswordTextField: JifflrTextFieldPassword!
    @IBOutlet weak var newPasswordHeadingLabel: UILabel!
    @IBOutlet weak var newPasswordTextField: JifflrTextFieldPassword!
    @IBOutlet weak var saveButton: JifflrButton!

    class func instantiateFromStoryboard() -> ChangePasswordViewController {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "ChangePasswordViewController") as! ChangePasswordViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
    }

    func setupUI() {
        self.setupLocalization()

        self.setBackgroundImage(image: UIImage(named: "MainBackground"))
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.setHidesBackButton(false, animated: false)

        self.saveButton.setBackgroundColor(color: UIColor.mainPink)
    }

    func setupLocalization() {
        self.title = "changePassword.navigation.title".localized()
        self.currentPasswordHeadingLabel.text = "changePassword.currentPassword.heading".localized()
        self.currentPasswordTextField.placeholder = "changePassword.currentPassword.placeholder".localized()
        self.newPasswordHeadingLabel.text = "changePassword.newPassword.heading".localized()
        self.newPasswordTextField.placeholder = "changePassword.newPassword.placeholder".localized()
        self.saveButton.setTitle("changePassword.saveButton.title".localized(), for: .normal)
    }

    @IBAction func saveButtonPressed(sender: UIButton) {

        guard let currentPassword = self.currentPasswordTextField.text, !currentPassword.isEmpty else {
            self.displayError(error: ErrorMessage.invalidCurrentPassword)
            return
        }

        guard let newPassword = self.newPasswordTextField.text, !newPassword.isEmpty, newPassword.count >= 8 else {
            self.displayError(error: ErrorMessage.invalidNewPassword)
            return
        }
    }
}
