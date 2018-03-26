//
//  AdBuilderOverviewViewController.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 26/03/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit

class AdBuilderOverviewViewController: BaseViewController {
    
    class func instantiateFromStoryboard() -> AdBuilderOverviewViewController {
        let storyboard = UIStoryboard(name: "AdBuilderOverview", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "AdBuilderOverviewViewController") as! AdBuilderOverviewViewController
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
    }
    
    func setupLocalization() {
        self.title = "adBuilderOverview.navigation.title".localized()
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
}
