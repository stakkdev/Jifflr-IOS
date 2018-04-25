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
    
    var myAds: MyAds?
    
    class func instantiateFromStoryboard(myAds: MyAds?) -> AdBuilderLandingViewController {
        let storyboard = UIStoryboard(name: "AdBuilderOverview", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AdBuilderLandingViewController") as! AdBuilderLandingViewController
        vc.myAds = myAds
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        self.setupData()
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
    
    func setupData() {
        if Reachability.isConnectedToNetwork() {
            AdBuilderManager.shared.countUserAds(completion: { (count) in
                self.routeBasedOnUserAdCount(count: count)
            })
        } else {
            AdBuilderManager.shared.countLocalUserAds(completion: { (count) in
                self.routeBasedOnUserAdCount(count: count)
            })
        }
    }
    
    func routeBasedOnUserAdCount(count: Int?) {
        guard let count = count else {
            self.pushToNoAds()
            return
        }

        self.spinner.stopAnimating()

        if count == 0 {
            self.pushToNoAds()
        } else {
            self.pushToAdOverview()
        }
    }
    
    func pushToNoAds() {
        let noAdsViewController = NoAdsViewController.instantiateFromStoryboard()
        self.navigationController?.pushViewController(noAdsViewController, animated: false)
    }
    
    func pushToAdOverview() {
        let overviewViewController = AdBuilderOverviewViewController.instantiateFromStoryboard(myAds: self.myAds)
        self.navigationController?.pushViewController(overviewViewController, animated: false)
    }
}
