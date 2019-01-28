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
        
        let newAdvertContent = self.createNewAd()
        let newAdvert = newAdvertContent.0
        let newContent = newAdvertContent.1

        AdBuilderManager.shared.saveAndPin(advert: newAdvert, content: newContent) { (error) in
            sender.stopAnimating()
            
            if let url = MediaManager.shared.get(id: nil, fileExtension: "jpg") {
                do {
                    let data = try Data(contentsOf: url)
                    guard MediaManager.shared.save(data: data, id: newAdvert.details?.objectId, fileExtension: "jpg") else {
                        self.displayError(error: ErrorMessage.mediaSaveFailed)
                        return
                    }
                } catch { }
            }

            guard error == nil else {
                self.displayError(error: error)
                return
            }
            
            if let campaign = CampaignManager.shared.campaignInEdit {
                campaign.advert = newAdvert
                campaign.status = CampaignStatusKey.pendingModeration
                campaign.saveInBackground(block: { (success, error) in
                    campaign.pinInBackground(withName: CampaignManager.shared.pinName)
                    CampaignManager.shared.campaignInEdit = nil
                    self.updateNavigationStackAfterSave()
                })
            } else {
                self.updateNavigationStackAfterSave()
            }
        }
    }
    
    func createNewAd() -> (Advert, [(question: Question, answers: [Answer])])  {
        let newDetails = AdvertDetails()
        if let image = self.advert.details?.image { newDetails.image = image }
        if let message = self.advert.details?.message { newDetails.message = message }
        newDetails.name = self.advert.details?.name ?? ""
        if let template = self.advert.details?.template { newDetails.template = template }
        newDetails.title = self.advert.details?.title ?? ""
        
        let newAdvert = Advert()
        newAdvert.isCMS = true
        newAdvert.details = newDetails
        newAdvert.creator = self.advert.creator
        
        var newContent: [(question: Question, answers: [Answer])] = []
        
        for contentTuple in self.content {
            let newQuestion = Question()
            if let creator = contentTuple.question.creator { newQuestion.creator = creator }
            if let image = contentTuple.question.image { newQuestion.image = image }
            if let index = contentTuple.question.index { newQuestion.index = index }
            if let noOfRequiredAnswers = contentTuple.question.noOfRequiredAnswers { newQuestion.noOfRequiredAnswers = noOfRequiredAnswers }
            newQuestion.text = contentTuple.question.text
            newQuestion.type = contentTuple.question.type
            
            var newAnswers: [Answer] = []
            for answer in contentTuple.answers {
                let newAnswer = Answer()
                if let date = answer.date { newAnswer.date = date }
                if let image = answer.image { newAnswer.image = image }
                newAnswer.index = answer.index
                newAnswer.questionType = answer.questionType
                newAnswer.text = answer.text
                newAnswer.urlType = answer.urlType
                
                newAnswers.append(newAnswer)
            }
            
            newContent.append((question: newQuestion, answers: newAnswers))
        }
        
        return (newAdvert, newContent)
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
        let vc = CreateScheduleViewController.instantiateFromStoryboard(advert: self.advert, campaign: nil, isEdit: false)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
