//
//  QAFeedbackViewController.swift
//  Ad-M8-iOS
//
//  Created by James Shaw on 11/10/2017.
//  Copyright © 2017 The Distance. All rights reserved.
//

import UIKit

class QAFeedbackViewController: FeedbackViewController {

    class func instantiateFromStoryboard(advert: Advert) -> QAFeedbackViewController {
        let storyboard = UIStoryboard(name: "Advert", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "QAFeedbackViewController") as! QAFeedbackViewController
        controller.advert = advert
        return controller
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func nextAd(_ sender: UIButton) {
        
    }
}
