//
//  TeamViewController+Invitations.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 28/02/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import Foundation
import UIKit
import MessageUI
import ContactsUI

extension TeamViewController {
    @objc func addButtonPressed(_ sender: UIBarButtonItem) {
        ContactsManager.shared.requestAccess { (access) in
            guard access == true else {
                self.displayError(error: ErrorMessage.contactsAccessFailed)
                return
            }

            let contactPickerViewController = CNContactPickerViewController()
            contactPickerViewController.delegate = self
            contactPickerViewController.displayedPropertyKeys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactEmailAddressesKey]
            self.navigationController?.present(contactPickerViewController, animated: true, completion: nil)
        }
    }
}

extension TeamViewController: CNContactPickerDelegate {
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        self.isDismissingContacts = true
        picker.dismiss(animated: true, completion: {
            
            let name = "\(contact.givenName) \(contact.familyName)"

            guard contact.emailAddresses.count > 0 else {
                let alert = UIAlertController(title: ErrorMessage.contactsNoEmail.failureTitle, message: ErrorMessage.contactsNoEmail.failureDescription, preferredStyle: .alert)
                let dismissAction = UIAlertAction(title: "error.dismiss".localized(), style: .cancel, handler: nil)
                let continueAction = UIAlertAction(title: "alert.notification.continue".localized(), style: .default, handler: { (alert) in
                    let vc = AddEmailViewController.instantiateFromStoryboard(name: name)
                    self.navigationController?.pushViewController(vc, animated: true)
                })
                
                alert.addAction(dismissAction)
                alert.addAction(continueAction)
                self.present(alert, animated: true, completion: nil)
                return
            }

            let email = contact.emailAddresses.first!.value as String
            self.createPendingUser(name: name, email: email)
        })
    }
    
    func createPendingUser(name: String, email: String) {
        var userInfo = [AnyHashable: Any]()
        userInfo["name"] = name
        userInfo["email"] = email
        
        PendingUserManager.shared.createPendingUser(withUserInfo: userInfo, completion: { (pendingUser, error) in
            guard let pendingUser = pendingUser, error == nil else {
                self.displayError(error: error)
                return
            }
            
            self.presentMail(name: name, email: email, pendingUser: pendingUser)
        })
    }

    func presentMail(name: String, email: String, pendingUser: PendingUser) {

        guard MFMailComposeViewController.canSendMail() == true else {
            self.displayError(error: ErrorMessage.inviteSendFailed)
            PendingUserManager.shared.deletePendingUser(pendingUser: pendingUser)
            return
        }

        let invitationCode = pendingUser.invitationCode

        let composeViewController = MFMailComposeViewController()
        composeViewController.mailComposeDelegate = self
        composeViewController.setToRecipients([email])
        composeViewController.setSubject("myTeam.inviteEmail.subject".localized())

        guard let shortName = name.components(separatedBy: " ").first else { return }
        let body = "myTeam.inviteEmail.body".localizedFormat(shortName, invitationCode)
        composeViewController.setMessageBody(body, isHTML: false)

        self.pendingUser = pendingUser
        self.navigationController?.present(composeViewController, animated: true, completion: nil)
    }
}

extension TeamViewController: MFMailComposeViewControllerDelegate {

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        self.segmentedControl.button2Pressed(sender: self.segmentedControl.button2)

        guard let pendingUser = self.pendingUser else { return }
        guard error == nil else {
            controller.dismiss(animated: true, completion: {
                self.displayError(error: ErrorMessage.inviteSendFailed)
            })
            return
        }

        switch result {
        case .sent:
            PendingUserManager.shared.pinPendingUser(pendingUser: pendingUser, completion: { (error) in
                guard error == nil else {
                    self.displayError(error: error)
                    return
                }
                
                controller.dismiss(animated: true, completion: {
                    let alert = AlertMessage.inviteSent(pendingUser.name)
                    self.displayMessage(title: alert.title, message: alert.message)
                })
            })

        case .failed:
            controller.dismiss(animated: true, completion: {
                self.displayError(error: ErrorMessage.inviteSendFailed)
                PendingUserManager.shared.deletePendingUser(pendingUser: pendingUser)
            })

        default:
            controller.dismiss(animated: true, completion: nil)
            PendingUserManager.shared.deletePendingUser(pendingUser: pendingUser)
        }

        self.pendingUser = nil
    }
}
