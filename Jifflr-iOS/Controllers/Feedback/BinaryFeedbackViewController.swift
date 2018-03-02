//
//  BinaryFeedbackViewController.swift
//  Ad-M8-iOS
//
//  Created by James Shaw on 11/10/2017.
//  Copyright © 2017 The Distance. All rights reserved.
//

import UIKit
import Parse

class BinaryFeedbackViewController: FeedbackViewController {

    class func instantiateFromStoryboard(advert: Advert, question: Question?) -> BinaryFeedbackViewController {
        let storyboard = UIStoryboard(name: "Advert", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "BinaryFeedbackViewController") as! BinaryFeedbackViewController
        controller.advert = advert
        controller.question = question
        return controller
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
