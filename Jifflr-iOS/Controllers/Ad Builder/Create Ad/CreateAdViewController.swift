//
//  CreateAdViewController.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 26/03/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit

class CreateAdViewController: BaseViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var textField: JifflrTextField!
    @IBOutlet weak var nextButton: JifflrButton!

    class func instantiateFromStoryboard() -> CreateAdViewController {
        let storyboard = UIStoryboard(name: "CreateAd", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "CreateAdViewController") as! CreateAdViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }
    
    func setupUI() {
        self.setupLocalization()
        
        self.setBackgroundImage(image: UIImage(named: "MainBackground"))
        self.nextButton.setBackgroundColor(color: UIColor.mainPink)
    }
    
    func setupLocalization() {
        self.title = "createAd.navigation.title".localized()
        self.nextButton.setTitle("createAd.nextButton.title".localized(), for: .normal)
        self.textField.placeholder = "createAd.textField.placeholder".localized()
        self.titleLabel.text = "createAd.titleLabel.title".localized()
        self.descriptionLabel.text = "createAd.descriptionLabel.title".localized()
    }
    
    @IBAction func nextButtonPressed(sender: UIButton) {
        guard let adName = self.textField.text, !adName.isEmpty else {
            self.displayError(error: ErrorMessage.createAdName)
            return
        }
        
        let advert = Advert()
        let details = AdvertDetails()
        details.name = adName
        advert.isCMS = true
        advert.details = details
        
        let vc = ChooseTemplateViewController.instantiateFromStoryboard(advert: advert)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
