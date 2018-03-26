//
//  AdBuilderLandingViewController.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 26/03/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit

class AdBuilderLandingViewController: BaseViewController {
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    class func instantiateFromStoryboard() -> AdBuilderLandingViewController {
        let storyboard = UIStoryboard(name: "AdBuilderOverview", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "AdBuilderLandingViewController") as! AdBuilderLandingViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { (timer) in
            self.pushToNoAds()
        }
    }
    
    func setupUI() {
        self.setupLocalization()
        
        self.setBackgroundImage(image: UIImage(named: "MainBackground"))
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.setHidesBackButton(false, animated: false)
        
        self.spinner.startAnimating()
    }
    
    func setupLocalization() {
        self.title = "adBuilderOverview.navigation.title".localized()
    }
    
    func pushToNoAds() {
        let noAdsViewController = NoAdsViewController.instantiateFromStoryboard()
        self.navigationController?.pushViewController(noAdsViewController, animated: false)
        
        guard self.navigationController?.viewControllers.count == 3 else { return }
        self.navigationController?.viewControllers.remove(at: 1)
    }
}
