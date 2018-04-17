//
//  AdCreatedViewController.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 10/04/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit

class AdCreatedViewController: BaseViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var saveAdButton: JifflrButton!
    @IBOutlet weak var createCampaignButton: JifflrButton!
    
    var advert: Advert!
    var content:[(question: Question, answers: [Answer])] = []

    class func instantiateFromStoryboard(advert: Advert, content: [(question: Question, answers: [Answer])]) -> AdCreatedViewController {
        let storyboard = UIStoryboard(name: "CreateAd", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AdCreatedViewController") as! AdCreatedViewController
        vc.advert = advert
        vc.content = content
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }
    
    func setupUI() {
        self.setupLocalization()
        self.setBackgroundImage(image: UIImage(named: "MainBackground"))
        
        self.title = self.advert.details?.name
        
        self.saveAdButton.setBackgroundColor(color: UIColor.mainPink)
        self.createCampaignButton.setBackgroundColor(color: UIColor.mainPink)
    }
    
    func setupLocalization() {
        self.saveAdButton.setTitle("adCreated.saveAdButton.title".localized(), for: .normal)
        self.createCampaignButton.setTitle("adCreated.createCampaignButton.title".localized(), for: .normal)
        self.titleLabel.text = "adCreated.titleLabel.text".localized()
        self.descriptionLabel.text = "adCreated.descriptionLabel.text".localized()
    }
    
    @IBAction func saveAdButtonPressed(sender: JifflrButton) {
        sender.animate()

        AdBuilderManager.shared.saveAndPin(advert: self.advert, content: self.content) { (error) in
            sender.stopAnimating()

            guard error == nil else {
                self.displayError(error: error)
                return
            }
            
            self.updateNavigationStackAfterSave()
        }
    }
    
    func updateNavigationStackAfterSave() {
        guard let viewControllers = self.navigationController?.viewControllers else { return }
        guard let dashboardViewController = viewControllers.first as? DashboardViewController else { return }
        var newViewControllers = viewControllers
        for (index, viewController) in newViewControllers.enumerated() {
            if let _ = viewController as? NoAdsViewController ?? viewController as? AdBuilderOverviewViewController  {
                newViewControllers.remove(at: index)
            }
        }
        
        let myAds = dashboardViewController.myAds
        if let myAds = myAds {
            if !myAds.adverts.contains(self.advert) {
                myAds.adverts.append(self.advert)
            }
        }
        
        let adBuilderLandingViewController = AdBuilderLandingViewController.instantiateFromStoryboard(myAds: myAds)
        newViewControllers.insert(adBuilderLandingViewController, at: 1)
        self.navigationController?.setViewControllers(newViewControllers, animated: false)
        self.navigationController?.popToViewController(adBuilderLandingViewController, animated: true)
    }
    
    @IBAction func createCampaignButtonPressed(sender: JifflrButton) {
        sender.animate()
        
        AdBuilderManager.shared.saveAndPin(advert: self.advert, content: self.content) { (error) in
            sender.stopAnimating()
            
            guard error == nil else {
                self.displayError(error: error)
                return
            }
            
            self.updateNavigationStackForCreateCampaign()
        }
    }
    
    func updateNavigationStackForCreateCampaign() {
        guard let viewControllers = self.navigationController?.viewControllers else { return }
        guard let dashboardViewController = viewControllers.first as? DashboardViewController else { return }
        var newViewControllers = viewControllers
        for (index, viewController) in newViewControllers.enumerated() {
            if let _ = viewController as? NoAdsViewController ?? viewController as? AdBuilderOverviewViewController  {
                newViewControllers.remove(at: index)
            }
        }
        
        let myAds = dashboardViewController.myAds
        if let myAds = myAds {
            if !myAds.adverts.contains(self.advert) {
                myAds.adverts.append(self.advert)
            }
        }
        
        let adBuilderLandingViewController = AdBuilderLandingViewController.instantiateFromStoryboard(myAds: myAds)
        newViewControllers.insert(adBuilderLandingViewController, at: 1)
        self.navigationController?.setViewControllers(newViewControllers, animated: false)
        let vc = CreateScheduleViewController.instantiateFromStoryboard(advert: self.advert)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
