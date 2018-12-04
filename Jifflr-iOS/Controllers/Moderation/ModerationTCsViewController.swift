//
//  ModerationTCsViewController.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 25/04/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit
import WebKit

class ModerationTCsViewController: BaseViewController {
    
    @IBOutlet weak var acceptLabel: UILabel!
    @IBOutlet weak var acceptSwitch: UISwitch!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var containerView: UIView!
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
        
        let screenWidth = UIScreen.main.bounds.width
        self.webView.frame = CGRect(x: 8.0, y: 8.0, width: screenWidth - 52.0, height: self.containerView.frame.height - 8.0)
        
        guard let url = Bundle.main.url(forResource: "TermsOfUseModerator", withExtension: "html") else { return }
        self.webView.loadFileURL(url, allowingReadAccessTo: url)
        let request = URLRequest(url: url)
        self.webView.load(request)
        self.webView.scrollView.setContentOffset(.zero, animated: false)
    }
    
    func setupUI() {
        self.setupLocalization()
        self.setBackgroundImage(image: UIImage(named: "MainBackground"))
        
        self.containerView.clipsToBounds = true
        self.containerView.layer.masksToBounds = true
        self.containerView.layer.cornerRadius = 10.0
        
        let webConfiguration = WKWebViewConfiguration()
        self.webView = WKWebView(frame: CGRect.zero, configuration: webConfiguration)
        self.containerView.addSubview(self.webView)
        
        self.handleBasedOnModeratorStatus()
    }
    
    func setupLocalization() {
        self.title = "moderationTCs.navigation.title".localized()
        self.acceptLabel.text = "moderationTCs.applyLabel.text".localized()
    }
    
    func handleBasedOnModeratorStatus() {
        guard let status = Session.shared.currentUser?.details.moderatorStatus else {
            self.applyButton.setTitle("moderationTCs.applyButton.applyTitle".localized(), for: .normal)
            self.applyButton.isEnabled = true
            self.applyButton.setBackgroundColor(color: UIColor.mainPink)
            return
        }
        
        switch status {
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
        guard let user = Session.shared.currentUser else { return }
        
        guard self.acceptSwitch.isOn else {
            self.displayError(error: ErrorMessage.applyModerator)
            return
        }
        
        self.applyButton.animate()
        user.details.moderatorStatus = ModeratorStatusKey.awaitingApproval
        user.details.saveInBackground(block: { (success, error) in
            guard error == nil else {
                self.applyButton.stopAnimating()
                self.displayError(error: ErrorMessage.applyModeratorFailedServer)
                return
            }
            
            user.details.pinInBackground(block: { (success, error) in
                self.applyButton.stopAnimating()
                self.handleBasedOnModeratorStatus()
                
                let alert = AlertMessage.applyModerator
                self.displayMessage(title: alert.title, message: alert.message, dismissText: nil, dismissAction: nil)
            })
        })
    }
}
