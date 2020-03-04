//
//  LoadingViewController.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 15/01/2019.
//  Copyright © 2019 The Distance. All rights reserved.
//

import UIKit

class LoadingViewController: BaseViewController {
    
    var timer: Timer?
    
    class func instantiateFromStoryboard() -> LoadingViewController {
        let storyboard = UIStoryboard(name: "Advert", bundle: nil)
        let loadingViewController = storyboard.instantiateViewController(withIdentifier: "LoadingViewController") as! LoadingViewController
        return loadingViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false, block: { (timer) in
            print("Fallback Timer Completed")
            self.rootDashboardViewController()
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.timer?.invalidate()
        self.timer = nil
    }
    
    func setupUI() {
        self.view.backgroundColor = UIColor.clear
        self.setBackgroundImage(image: UIImage(named: "MainBackground"))
    }
}
