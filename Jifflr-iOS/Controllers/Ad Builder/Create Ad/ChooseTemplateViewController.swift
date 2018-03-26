//
//  ChooseTemplateViewController.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 26/03/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit

class ChooseTemplateViewController: BaseViewController {

    class func instantiateFromStoryboard() -> ChooseTemplateViewController {
        let storyboard = UIStoryboard(name: "CreateAd", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "ChooseTemplateViewController") as! ChooseTemplateViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }
    
    func setupUI() {
        self.setupLocalization()
        
        self.setBackgroundImage(image: UIImage(named: "MainBackground"))
    }
    
    func setupLocalization() {
        self.title = "chooseTemplate.navigation.title".localized()
    }
}
