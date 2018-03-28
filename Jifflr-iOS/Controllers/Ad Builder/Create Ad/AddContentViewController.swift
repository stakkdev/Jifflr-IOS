//
//  AddContentViewController.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 27/03/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit

class AddContentViewController: BaseViewController {
    
    @IBOutlet weak var titleTextField: JifflrTextField!
    @IBOutlet weak var messageTextView: JifflrTextView!
    @IBOutlet weak var imageOverlayView: UIImageView!
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var previewButton: JifflrButton!
    @IBOutlet weak var nextButton: JifflrButton!
    
    var advert: Advert!

    class func instantiateFromStoryboard(advert: Advert) -> AddContentViewController {
        let storyboard = UIStoryboard(name: "CreateAd", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AddContentViewController") as! AddContentViewController
        vc.advert = advert
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }
    
    func setupUI() {
        self.setupLocalization()
        self.setupConstraints()
        self.setBackgroundImage(image: UIImage(named: "MainBackground"))
        
        self.nextButton.setBackgroundColor(color: UIColor.mainPink)
        self.previewButton.setBackgroundColor(color: UIColor.mainBlueTransparent80)
    }
    
    func setupLocalization() {
        self.title = "addContent.navigation.title".localized()
        self.nextButton.setTitle("createAd.nextButton.title".localized(), for: .normal)
        self.previewButton.setTitle("addContent.previewButton.title".localized(), for: .normal)
        self.titleTextField.placeholder = "addContent.titleTextField.placeholder".localized()
        self.messageTextView.placeholder = "addContent.messageTextView.placeholder".localized()
        self.imageButton.setTitle("addContent.imageButton.title".localized(), for: .normal)
        self.imageButton.setImage(UIImage(named: "AddImageButton"), for: .normal)
    }
    
    @IBAction func previewButtonPressed(sender: UIButton) {
//        guard let template = self.advert.details?.template else { return }
//
//        guard self.validateInput(key: template.key) else {
//            self.displayError(error: ErrorMessage.addContent)
//            return
//        }
        
        let vc = CMSAdvertViewController.instantiateFromStoryboard(advert: self.advert, isPreview: true)
        let navController = UINavigationController(rootViewController: vc)
        navController.isNavigationBarHidden = true
        self.navigationController?.present(navController, animated: true, completion: nil)
    }
    
    @IBAction func nextButtonPressed(sender: UIButton) {
        guard let template = self.advert.details?.template else { return }
        
        guard self.validateInput(key: template.key) else {
            self.displayError(error: ErrorMessage.addContent)
            return
        }
        
        // TODO: Push to next screen
    }
    
    func validateInput(key: String) -> Bool {
        
        switch key {
        case AdvertTemplateKey.imageVideoPortait:
            return self.validateImage()
        case AdvertTemplateKey.imageVideoLandscape:
            return self.validateImage()
        case AdvertTemplateKey.titleMessageImage:
            return self.validateTextAndImage()
        case AdvertTemplateKey.titleImageMessage:
            return self.validateTextAndImage()
        case AdvertTemplateKey.imageTitleMessage:
            return self.validateTextAndImage()
        default:
            return false
        }
    }
    
    func validateTextAndImage() -> Bool {
        guard let title = self.titleTextField.text, !title.isEmpty else { return false }
        guard let message = self.messageTextView.text, !message.isEmpty else { return false }
        guard self.advert.details?.image != nil else { return false }
        
        self.advert.details?.title = title
        self.advert.details?.message = message
        
        return true
    }
    
    func validateImage() -> Bool {
        guard self.advert.details?.image != nil else { return false }
        return true
    }
}
