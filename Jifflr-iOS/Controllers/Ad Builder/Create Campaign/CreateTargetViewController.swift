//
//  CreateTargetViewController.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 16/04/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit

class CreateTargetViewController: BaseViewController {
    
    var campaign: Campaign!

    class func instantiateFromStoryboard(campaign: Campaign) -> CreateTargetViewController {
        let storyboard = UIStoryboard(name: "CreateCampaign", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CreateTargetViewController") as! CreateTargetViewController
        vc.campaign = campaign
        return vc
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
        self.title = "createSchedule.navigation.title".localized()
    }
}
