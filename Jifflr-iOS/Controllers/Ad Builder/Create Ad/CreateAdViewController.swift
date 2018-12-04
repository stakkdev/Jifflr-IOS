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
    
    var advert: Advert?

    class func instantiateFromStoryboard(advert: Advert?) -> CreateAdViewController {
        let storyboard = UIStoryboard(name: "CreateAd", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CreateAdViewController") as! CreateAdViewController
        vc.advert = advert
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }
    
    func setupUI() {
        self.setupLocalization()
        
        self.setBackgroundImage(image: UIImage(named: "MainBackground"))
        self.nextButton.setBackgroundColor(color: UIColor.mainPink)
        
        if let advert = self.advert {
            self.textField.text = advert.details?.name
        }
    }
    
    func setupLocalization() {
        self.title = "createAd.navigation.title".localized()
        self.nextButton.setTitle("createAd.nextButton.title".localized(), for: .normal)
        self.textField.placeholder = "createAd.textField.placeholder".localized()
        self.titleLabel.text = "createAd.titleLabel.title".localized()
        self.descriptionLabel.text = "createAd.descriptionLabel.title".localized()
    }
    
    @IBAction func nextButtonPressed(sender: UIButton) {
        guard let adName = self.textField.text, !adName.isEmpty, let user = Session.shared.currentUser else {
            self.displayError(error: ErrorMessage.createAdName)
            return
        }
        
        if let advert = self.advert {
            advert.details?.name = adName
        } else {
            self.advert = Advert()
            let details = AdvertDetails()
            details.name = adName
            self.advert?.isCMS = true
            self.advert?.details = details
            self.advert?.creator = user
        }
        
        guard let advert = self.advert else { return }
        let vc = ChooseTemplateViewController.instantiateFromStoryboard(advert: advert)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
