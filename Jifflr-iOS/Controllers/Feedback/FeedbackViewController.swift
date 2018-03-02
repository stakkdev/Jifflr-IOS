//
//  FeedbackViewController.swift
//  Ad-M8-iOS
//
//  Created by James Shaw on 11/10/2017.
//  Copyright © 2017 The Distance. All rights reserved.
//

import UIKit
import Parse

class FeedbackViewController: UIViewController, DisplayMessage {

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var nextAdButton: UIButton!

    var isoCountryCode = ""
    var fetchedLocation = false

    var advert: Advert!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationBar.delegate = self
        self.questionLabel.text = "Hello"// advert.feedbackQuestion.question
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        NotificationCenter.default.addObserver(self, selector: #selector(locationFound(_:)), name: Constants.Notifications.locationFound, object: nil)

        LocationManager.shared.getCurrentLocation()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        NotificationCenter.default.removeObserver(self, name: Constants.Notifications.locationFound, object: nil)
    }

    @objc func locationFound(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo as? [String: String],
            let isoCountryCode = userInfo["isoCountryCode"] else {
                self.displayMessage(title: ErrorMessage.locationFailed.failureTitle, message: ErrorMessage.locationFailed.failureDescription)
                return
        }

        self.isoCountryCode = isoCountryCode
        self.fetchedLocation = true
    }

    @IBAction func close(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

//    func saveFeedback(userFeedback: UserFeedback) {
//        guard self.fetchedLocation == true else {
//            self.displayMessage(title: ErrorMessage.locationFailed.failureTitle, message: ErrorMessage.locationFailed.failureDescription)
//            LocationManager.shared.getCurrentLocation()
//            return
//        }
//
//        FeedbackManager.shared.saveFeedback(userFeedback: userFeedback, isoCountryCode: self.isoCountryCode, advert: self.advert) { (error) in
//            guard error == nil else {
//                self.displayMessage(title: ErrorMessage.feedbackSaveFailed.failureTitle, message: ErrorMessage.feedbackSaveFailed.failureDescription)
//                return
//            }
//
//            self.dismiss(animated: true, completion: nil)
//        }
//    }
}

extension FeedbackViewController: UINavigationBarDelegate {
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}
