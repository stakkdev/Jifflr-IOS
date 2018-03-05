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

    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var yesButton: UIButton!

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

    @IBAction func noPressed(sender: UIButton) {
        if sender.tag == 0 {
            sender.tag = 1
            sender.setImage(UIImage(named: "FeedbackNoButtonSelected"), for: .normal)

            self.yesButton.tag = 0
            self.yesButton.setImage(UIImage(named: "FeedbackYesButton"), for: .normal)
        }
    }

    @IBAction func yesPressed(sender: UIButton) {
        if sender.tag == 0 {
            sender.tag = 1
            sender.setImage(UIImage(named: "FeedbackYesButtonSelected"), for: .normal)

            self.noButton.tag = 0
            self.noButton.setImage(UIImage(named: "FeedbackNoButton"), for: .normal)
        }
    }

    override func validateAnswers() -> Bool {
        if self.noButton.tag == 0 && self.yesButton.tag == 0 {
            return false
        }

        return true
    }
}
