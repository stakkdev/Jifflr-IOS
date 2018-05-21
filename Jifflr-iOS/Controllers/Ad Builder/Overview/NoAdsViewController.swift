//
//  NoAdsViewController.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 26/03/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit

class NoAdsViewController: BaseViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var becomeModeratorButton: JifflrButton!
    @IBOutlet weak var createAdButton: JifflrButton!
    
    class func instantiateFromStoryboard() -> NoAdsViewController {
        let storyboard = UIStoryboard(name: "AdBuilderOverview", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "NoAdsViewController") as! NoAdsViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        self.updateNavigationStack()
    }
    
    func setupUI() {
        self.setupLocalization()
        
        self.setBackgroundImage(image: UIImage(named: "MainBackground"))
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.setHidesBackButton(false, animated: false)
        
        self.becomeModeratorButton.setBackgroundColor(color: UIColor.mainGreen)
        self.createAdButton.setBackgroundColor(color: UIColor.mainPink)
        
        self.handleModeratorStatus()
    }
    
    func setupLocalization() {
        self.title = "adBuilderOverview.navigation.title".localized()
        self.titleLabel.text = "adBuilderNoAds.titleLabel.title".localized()
        self.descriptionLabel.text = "adBuilderNoAds.descriptionLabel.title".localized()
        self.becomeModeratorButton.setTitle("adBuilderNoAds.becomeModeratorButton.title".localized(), for: .normal)
        self.createAdButton.setTitle("adBuilderNoAds.createAdButton.title".localized(), for: .normal)
    }
    
    func updateNavigationStack() {
        guard let navController = self.navigationController else { return }
        for (index, viewController) in navController.viewControllers.enumerated() {
            if let _ = viewController as? AdBuilderLandingViewController {
                navController.viewControllers.remove(at: index)
                return
            }
        }
    }
    
    func handleModeratorStatus() {
        self.becomeModeratorButton.isHidden = true
        self.becomeModeratorButton.isEnabled = false
        
        guard let moderationStatus = Session.shared.currentUser?.details.moderatorStatus else { return }
        if moderationStatus == ModeratorStatusKey.isModerator {
            self.becomeModeratorButton.isHidden = true
            self.becomeModeratorButton.isEnabled = false
        } else {
            self.becomeModeratorButton.isHidden = false
            self.becomeModeratorButton.isEnabled = true
        }
    }
    
    @IBAction func becomeModeratorPressed(sender: UIButton) {
        self.navigationController?.pushViewController(ModerationTCsViewController.instantiateFromStoryboard(), animated: true)
    }
    
    @IBAction func createAdPressed(sender: UIButton) {
        self.navigationController?.pushViewController(CreateAdViewController.instantiateFromStoryboard(advert: nil), animated: true)
    }
}
