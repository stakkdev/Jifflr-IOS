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

    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dislikeButton: UIButton!

    class func instantiateFromStoryboard(advert: Advert) -> BinaryFeedbackViewController {
        let storyboard = UIStoryboard(name: "Advert", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "BinaryFeedbackViewController") as! BinaryFeedbackViewController
        controller.advert = advert
        return controller
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func likePressed(_ sender: UIButton) {
        self.likeButton.tag = 1
        self.likeButton.setTitleColor(UIColor.blue, for: .normal)

        self.dislikeButton.tag = 0
        self.dislikeButton.setTitleColor(UIColor.lightGray, for: .normal)

        self.nextAdButton.isEnabled = true
    }

    @IBAction func dislikePressed(_ sender: UIButton) {
        self.dislikeButton.tag = 1
        self.dislikeButton.setTitleColor(UIColor.blue, for: .normal)

        self.likeButton.tag = 0
        self.likeButton.setTitleColor(UIColor.lightGray, for: .normal)

        self.nextAdButton.isEnabled = true
    }

    @IBAction func nextAd(_ sender: UIButton) {
        guard self.likeButton.tag == 1 || self.dislikeButton.tag == 1 else {
            return
        }

        let likes = self.likeButton.tag == 1 ? true : false
        let binaryFeedback = UserFeedback()
        binaryFeedback.likes = likes
        self.saveFeedback(userFeedback: binaryFeedback)
    }
}
