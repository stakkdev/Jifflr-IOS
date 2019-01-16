//
//  LoadingViewController.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 15/01/2019.
//  Copyright © 2019 The Distance. All rights reserved.
//

import UIKit

class LoadingViewController: BaseViewController {
    
    class func instantiateFromStoryboard() -> LoadingViewController {
        let storyboard = UIStoryboard(name: "Advert", bundle: nil)
        let loadingViewController = storyboard.instantiateViewController(withIdentifier: "LoadingViewController") as! LoadingViewController
        return loadingViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }
    
    func setupUI() {
        self.view.backgroundColor = UIColor.clear
        self.backgroundImageView.backgroundColor = UIColor.clear
    }
}
