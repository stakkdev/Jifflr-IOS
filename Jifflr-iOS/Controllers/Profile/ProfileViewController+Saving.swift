//
//  ProfileViewController+Saving.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 20/02/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import Foundation

extension ProfileViewController {
    func validateField(textField: UITextField) {
        guard let currentUser = Session.shared.currentUser else { return }

        if textField == self.firstNameTextField {
            guard let firstName = self.firstNameTextField.text, !firstName.isEmpty else {
                let error = ErrorMessage.invalidProfileField("register.firstName.heading".localized())
                self.displayMessage(title: error.failureTitle, message: error.failureDescription)
                return
            }

            currentUser.details.firstName = firstName
            self.saveAndPinUser()

        } else if textField == self.lastNameTextField {
            guard let lastName = self.lastNameTextField.text, !lastName.isEmpty else {
                let error = ErrorMessage.invalidProfileField("register.lastName.heading".localized())
                self.displayMessage(title: error.failureTitle, message: error.failureDescription)
                return
            }

            currentUser.details.lastName = lastName
            self.saveAndPinUser()

        } else if textField == self.emailTextField {
            guard let email = self.emailTextField.text, !email.isEmpty else {
                let error = ErrorMessage.invalidProfileField("register.email.heading".localized())
                self.displayMessage(title: error.failureTitle, message: error.failureDescription)
                return
            }

            self.checkEmailAndSaveUser(email: email)

        } else if textField == self.locationTextField {
            guard let displayLocation = self.locationTextField.text, !displayLocation.isEmpty,
                let location = self.locationTextField.location,
                let geoPoint = self.locationTextField.geoPoint else {
                    let error = ErrorMessage.invalidProfileField("register.location.heading".localized())
                    self.displayMessage(title: error.failureTitle, message: error.failureDescription)
                    return
            }

            currentUser.details.displayLocation = displayLocation
            currentUser.details.location = location
            currentUser.details.geoPoint = geoPoint
            self.saveAndPinUser()

        } else if textField == self.dobTextField {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"

            guard let dob = self.dobTextField.text, !dob.isEmpty, let dateOfBirth = dateFormatter.date(from: dob) else {
                let error = ErrorMessage.invalidProfileField("register.dob.heading".localized())
                self.displayMessage(title: error.failureTitle, message: error.failureDescription)
                return
            }

            guard let minimumDate = Calendar.current.date(byAdding: .year, value: -18, to: Date()), minimumDate > dateOfBirth else {
                self.dobTextField.text = dateFormatter.string(from: currentUser.details.dateOfBirth)
                let error = ErrorMessage.invalidDobProfile
                self.displayMessage(title: error.failureTitle, message: error.failureDescription)
                return
            }

            currentUser.details.dateOfBirth = dateOfBirth
            self.saveAndPinUser()

        } else if textField == self.genderTextField {
            guard let gender = self.genderTextField.text, !gender.isEmpty else {
                let error = ErrorMessage.invalidProfileGender
                self.displayMessage(title: error.failureTitle, message: error.failureDescription)
                return
            }

            currentUser.details.gender = gender
            self.saveAndPinUser()

        }
    }

    func saveAndPinUser() {
        guard let currentUser = Session.shared.currentUser else { return }

        currentUser.saveAndPin { (error) in
            guard error == nil else {
                self.displayMessage(title: error!.failureTitle, message: error!.failureDescription)
                return
            }
        }
    }

    func checkEmailAndSaveUser(email: String) {
        guard let currentUser = Session.shared.currentUser else { return }

        UserManager.shared.usernameAvailable(email: email, completion: { (available, error) in
            guard let available = available, error == nil else {
                if let error = error {
                    self.displayMessage(title: error.failureTitle, message: error.failureDescription)
                }
                return
            }

            if available == true {
                currentUser.email = email
                currentUser.username = email
                self.saveAndPinUser()
            } else {
                let error = ErrorMessage.userAlreadyExists
                self.displayMessage(title: error.failureTitle, message: error.failureDescription)
                return
            }
        })
    }

    func changeTeam(invitationCode: String) {
        guard let currentUser = Session.shared.currentUser else { return }

        UserManager.shared.changeTeam(invitationCode: invitationCode) { (error) in
            self.invitationCodeTextField.text = currentUser.details.invitationCode

            guard error == nil else {
                self.displayError(error: error)
                return
            }

            self.displayMessage(title: AlertMessage.teamChanged.title, message: AlertMessage.teamChanged.message)
        }
    }
}
