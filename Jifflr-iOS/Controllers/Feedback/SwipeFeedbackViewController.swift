//
//  SwipeFeedbackViewController.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 06/03/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit

class SwipeFeedbackViewController: FeedbackViewController {

    var questions:[Question] = []

    class func instantiateFromStoryboard(advert: Advert, questions: [Question]) -> SwipeFeedbackViewController {
        let storyboard = UIStoryboard(name: "Advert", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SwipeFeedbackViewController") as! SwipeFeedbackViewController
        controller.advert = advert
        controller.questions = questions
        return controller
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func setupUI() {
        super.setupUI()

        self.nextAdButton.isEnabled = false
        self.nextAdButton.isHidden = true
    }
}
