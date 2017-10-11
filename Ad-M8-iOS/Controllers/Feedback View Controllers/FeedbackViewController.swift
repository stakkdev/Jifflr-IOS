//
//  FeedbackViewController.swift
//  Ad-M8-iOS
//
//  Created by James Shaw on 11/10/2017.
//  Copyright © 2017 The Distance. All rights reserved.
//

import UIKit

class FeedbackViewController: UIViewController {

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var nextAdButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationBar.delegate = self
    }

    @IBAction func close(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

    func saveBinaryFeedback(like: Bool) {
        // TODO: SAVE FEEDBACK
        self.dismiss(animated: true, completion: nil)
    }

    func saveRatingFeedback(rating: Int) {
        // TODO: SAVE FEEDBACK
        self.dismiss(animated: true, completion: nil)
    }

    func saveAnswerFeedback(answers: [Int]) {
        // TODO: SAVE FEEDBACK
        self.dismiss(animated: true, completion: nil)
    }
}

extension FeedbackViewController: UINavigationBarDelegate {
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}
