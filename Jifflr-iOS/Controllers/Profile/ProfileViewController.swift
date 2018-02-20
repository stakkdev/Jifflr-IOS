//
//  ProfileViewController.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 20/02/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit

class ProfileViewController: BaseViewController {

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
    @IBOutlet weak var logoutButton: JifflrButton!
    @IBOutlet weak var deleteAccountButton: JifflrButton!

    class func instantiateFromStoryboard() -> ProfileViewController {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
    }

    func setupUI() {
        self.setupLocalization()
        self.setupData()

        self.setBackgroundImage(image: UIImage(named: "MainBackground"))
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.setHidesBackButton(false, animated: false)

        self.scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 900.0)
        self.logoutButton.setBackgroundColor(color: UIColor.mainPink)
        self.deleteAccountButton.setBackgroundColor(color: UIColor.mainBlueTransparent80)
    }

    func setupLocalization() {
        self.title = "profile.navigation.title".localized()
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
        self.deleteAccountButton.setTitle("profile.deleteAccountButton.title".localized(), for: .normal)
        self.logoutButton.setTitle("profile.logoutButton.title".localized(), for: .normal)
    }

    func setupData() {
        guard let currentUser = Session.shared.currentUser else { return }

        self.firstNameTextField.text = currentUser.details.firstName
        self.lastNameTextField.text = currentUser.details.lastName
        self.emailTextField.text = currentUser.email
        self.passwordTextField.text = currentUser.password
        self.locationTextField.text = currentUser.details.displayLocation

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        self.dobTextField.text = dateFormatter.string(from: currentUser.details.dateOfBirth)

        self.genderTextField.text = currentUser.details.gender
        self.invitationCodeTextField.text = currentUser.details.invitationCode

        if currentUser.canEditInvitationCode() {
            self.invitationCodeTextField.isUserInteractionEnabled = true
            self.invitationCodeTextField.textColor = UIColor.mainBlue
        } else {
            self.invitationCodeTextField.isUserInteractionEnabled = false
            self.invitationCodeTextField.textColor = UIColor.lightGray
        }
    }

    @IBAction func logoutButtonPressed(sender: UIButton) {

    }

    @IBAction func deleteAccountButtonPressed(sender: UIButton) {

    }
}
