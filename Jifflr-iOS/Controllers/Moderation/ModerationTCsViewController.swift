//
//  ModerationTCsViewController.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 25/04/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit

class ModerationTCsViewController: BaseViewController {
    
    @IBOutlet weak var acceptLabel: UILabel!
    @IBOutlet weak var acceptSwitch: UISwitch!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var applyButton: JifflrButton!
    
    class func instantiateFromStoryboard() -> ModerationTCsViewController {
        let storyboard = UIStoryboard(name: "Moderation", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "ModerationTCsViewController") as! ModerationTCsViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.textView.setContentOffset(.zero, animated: false)
    }
    
    func setupUI() {
        self.setupLocalization()
        self.setBackgroundImage(image: UIImage(named: "MainBackground"))
        
        self.textView.clipsToBounds = true
        self.textView.layer.masksToBounds = true
        self.textView.layer.cornerRadius = 10.0
        self.textView.textContainerInset = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
        
        self.handleBasedOnModeratorStatus()
    }
    
    func setupLocalization() {
        self.title = "moderationTCs.navigation.title".localized()
        self.textView.text = "moderationTCs.content".localized()
        self.acceptLabel.text = "moderationTCs.applyLabel.text".localized()
    }
    
    func handleBasedOnModeratorStatus() {
        guard let status = Session.shared.currentUser?.details.moderatorStatus else {
            self.applyButton.setTitle("moderationTCs.applyButton.applyTitle".localized(), for: .normal)
            self.applyButton.isEnabled = true
            self.applyButton.setBackgroundColor(color: UIColor.mainPink)
            return
        }
        
        switch status.key {
        case ModeratorStatusKey.notModerator:
            AppSettingsManager.shared.canBecomeModerator { (yes) in
                self.applyButton.setTitle("moderationTCs.applyButton.applyTitle".localized(), for: .normal)
                self.applyButton.isEnabled = yes
                self.acceptSwitch.isEnabled = yes
                self.applyButton.setBackgroundColor(color: UIColor.mainPink)
                self.applyButton.alpha = yes ? 1.0 : 0.5
            }
        case ModeratorStatusKey.awaitingApproval:
            self.applyButton.setTitle("moderationTCs.applyButton.awaitingApprovalTitle".localized(), for: .normal)
            self.applyButton.isEnabled = false
            self.acceptSwitch.isEnabled = false
            self.applyButton.setBackgroundColor(color: UIColor.mainPink)
            self.applyButton.alpha = 0.5
        case ModeratorStatusKey.isModerator:
            self.applyButton.setTitle("moderationTCs.applyButton.applyTitle".localized(), for: .normal)
            self.applyButton.isEnabled = false
            self.acceptSwitch.isEnabled = false
            self.applyButton.setBackgroundColor(color: UIColor.mainPink)
            self.applyButton.alpha = 0.5
        default:
            return
        }
    }
    
    @IBAction func applyButtonPressed(sender: JifflrButton) {
        
    }
}
