//
//  QAFeedbackViewController.swift
//  Ad-M8-iOS
//
//  Created by James Shaw on 11/10/2017.
//  Copyright © 2017 The Distance. All rights reserved.
//

import UIKit

class QAFeedbackViewController: FeedbackViewController {

    class func instantiateFromStoryboard() -> QAFeedbackViewController {
        let storyboard = UIStoryboard(name: "Advert", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "QAFeedbackViewController") as! QAFeedbackViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func nextAd(_ sender: UIButton) {
        self.saveAnswerFeedback(answers: [1, 2, 3])
    }
}
