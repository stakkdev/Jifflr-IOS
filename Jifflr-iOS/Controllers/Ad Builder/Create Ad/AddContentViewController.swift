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
    @IBOutlet weak var imageOverlayView: UIView!
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
    }
    
    @IBAction func previewButtonPressed(sender: UIButton) {
    
    }
    
    @IBAction func nextButtonPressed(sender: UIButton) {
        
    }
}
