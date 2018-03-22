//
//  ChangeInvitationViewController.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 22/03/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit

class ChangeInvitationViewController: BaseViewController {
    
    @IBOutlet weak var nameTextField: JifflrTextField!
    @IBOutlet weak var nameHeadingLabel: UILabel!
    @IBOutlet weak var emailTextField: JifflrTextField!
    @IBOutlet weak var emailHeadingLabel: UILabel!
    @IBOutlet weak var invitationCodeTextField: JifflrTextField!
    @IBOutlet weak var invitationCodeHeadingLabel: UILabel!
    @IBOutlet weak var resendButton: JifflrButton!
    
    var pendingUser: PendingUser!
    
    class func instantiateFromStoryboard(pendingUser: PendingUser) -> ChangeInvitationViewController {
        let storyboard = UIStoryboard(name: "MyTeam", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ChangeInvitationViewController") as! ChangeInvitationViewController
        vc.pendingUser = pendingUser
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }
    
    func setupUI() {
        self.setupLocalization()
        self.setupData()
        
        self.setBackgroundImage(image: UIImage(named: "MainBackground"))
        self.resendButton.setBackgroundColor(color: UIColor.mainPink)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.setHidesBackButton(false, animated: false)
        
        self.invitationCodeTextField.isEnabled = false
        self.invitationCodeTextField.backgroundColor = UIColor.mainWhiteTransparent40
    }
    
    func setupLocalization() {
        self.title = "changeInvitation.navigation.title".localized()
        self.nameHeadingLabel.text = "changeInvitation.name.heading".localized()
        self.nameTextField.placeholder = "changeInvitation.name.placeholder".localized()
        self.emailHeadingLabel.text = "changeInvitation.email.heading".localized()
        self.emailTextField.placeholder = "changeInvitation.email.placeholder".localized()
        self.invitationCodeHeadingLabel.text = "changeInvitation.invitationCode.heading".localized()
        self.resendButton.setTitle("changeInvitation.resendButton.title".localized(), for: .normal)
    }
    
    func setupData() {
        self.nameTextField.text = self.pendingUser.name
        self.emailTextField.text = self.pendingUser.email
        self.invitationCodeTextField.text = self.pendingUser.objectId
    }
    
    @IBAction func resendButtonPressed(sender: UIButton) {
        guard let name = self.nameTextField.text, !name.isEmpty else {
            self.displayError(error: ErrorMessage.changeInvitationName)
            return
        }
        
        guard let email = self.emailTextField.text, !email.isEmpty, email.isEmail() else {
            self.displayError(error: ErrorMessage.changeInvitationEmail)
            return
        }
        
        //self.pendingUser.name = name
        //self.pendingUser.email = email
    }
}
