//
//  AddContactViewController.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 09/07/2020.
//  Copyright © 2020 The Distance. All rights reserved.
//

import UIKit

class AddContactViewController: BaseViewController {

    class func instantiateFromStoryboard() -> AddContactViewController {
        let storyboard = UIStoryboard(name: "MyTeam", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AddContactViewController") as! AddContactViewController
        return vc
    }
    
    @IBOutlet weak var emailHeadingLabel: UILabel!
    @IBOutlet weak var emailTextField: JifflrTextField!
    @IBOutlet weak var nameHeadingLabel: UILabel!
    @IBOutlet weak var nameTextField: JifflrTextField!
    @IBOutlet weak var sendButton: JifflrButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }
    
    func setupUI() {
        self.setupLocalization()
        
        self.setBackgroundImage(image: UIImage(named: "MainBackground"))
        self.sendButton.setBackgroundColor(color: UIColor.mainPink)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.setHidesBackButton(false, animated: false)
    }
    
    func setupLocalization() {
        self.title = "addContact.navigation.title".localized()
        self.emailHeadingLabel.text = "addContact.email.heading".localized()
        self.emailTextField.placeholder = "addContact.email.placeholder".localized()
        self.nameHeadingLabel.text = "addContact.name.heading".localized()
        self.nameTextField.placeholder = "addContact.name.placeholder".localized()
        self.sendButton.setTitle("addContact.sendButton.title".localized(), for: .normal)
    }
    
    @IBAction func sendButtonPressed(sender: UIButton) {
        guard let name = self.nameTextField.text, !name.isEmpty else {
            self.displayError(error: ErrorMessage.addEmailInvalid)
            return
        }
        
        guard let email = self.emailTextField.text, !email.isEmpty, email.isEmail() else {
            self.displayError(error: ErrorMessage.addEmailInvalid)
            return
        }
        
        guard let teamViewController = self.navigationController?.viewControllers[1] as? TeamViewController else { return }
        
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            teamViewController.createPendingUser(name: name, email: email)
        }
        
        self.navigationController?.popViewController(animated: true)
        CATransaction.commit()
    }
}
