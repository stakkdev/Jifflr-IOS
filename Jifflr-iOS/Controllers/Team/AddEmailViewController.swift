//
//  AddEmailViewController.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 17/12/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit

class AddEmailViewController: BaseViewController {
    
    class func instantiateFromStoryboard(name: String) -> AddEmailViewController {
        let storyboard = UIStoryboard(name: "MyTeam", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AddEmailViewController") as! AddEmailViewController
        vc.name = name
        return vc
    }
    
    @IBOutlet weak var emailHeadingLabel: UILabel!
    @IBOutlet weak var emailTextField: JifflrTextField!
    @IBOutlet weak var sendButton: JifflrButton!
    
    var name: String!

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
        self.title = "addEmail.navigation.title".localized()
        self.emailHeadingLabel.text = "addEmail.email.heading".localized()
        self.emailTextField.placeholder = "addEmail.email.placeholder".localized()
        self.sendButton.setTitle("addEmail.sendButton.title".localized(), for: .normal)
    }
    
    @IBAction func sendButtonPressed(sender: UIButton) {
        guard let email = self.emailTextField.text, !email.isEmpty, email.isEmail() else {
            self.displayError(error: ErrorMessage.addEmailInvalid)
            return
        }
        
        guard let teamViewController = self.navigationController?.viewControllers[1] as? TeamViewController else { return }
        
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            teamViewController.createPendingUser(name: self.name, email: email)
        }
        
        self.navigationController?.popViewController(animated: true)
        CATransaction.commit()
    }
}
