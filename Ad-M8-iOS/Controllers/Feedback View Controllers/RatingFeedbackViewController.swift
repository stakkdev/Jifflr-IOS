//
//  RatingFeedbackViewController.swift
//  Ad-M8-iOS
//
//  Created by James Shaw on 11/10/2017.
//  Copyright © 2017 The Distance. All rights reserved.
//

import UIKit

class RatingFeedbackViewController: FeedbackViewController {

    class func instantiateFromStoryboard() -> RatingFeedbackViewController {
        let storyboard = UIStoryboard(name: "Advert", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "RatingFeedbackViewController") as! RatingFeedbackViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func nextAd(_ sender: UIButton) {
        self.saveRatingFeedback(rating: 1)
    }
}
