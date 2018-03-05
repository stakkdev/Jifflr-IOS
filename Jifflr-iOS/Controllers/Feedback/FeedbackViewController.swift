//
//  FeedbackViewController.swift
//  Ad-M8-iOS
//
//  Created by James Shaw on 11/10/2017.
//  Copyright © 2017 The Distance. All rights reserved.
//

import UIKit
import Parse

class FeedbackViewController: BaseViewController {

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var nextAdButton: UIButton!

    var advert: Advert!
    var question: Question?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
    }

    func setupUI() {
        self.setupLocalization()

        self.setBackgroundImage(image: UIImage(named: "MainBackground"))
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.setHidesBackButton(true, animated: false)

        let skipBarButton = UIBarButtonItem(title: "onboarding.skipButton".localized(), style: .plain, target: self, action: #selector(self.skipButtonPressed(sender:)))
        self.navigationItem.rightBarButtonItem = skipBarButton

        self.questionLabel.text = "This screen will be implemented in the next sprint."
    }

    func setupLocalization() { }

    @IBAction func close(_ sender: UIBarButtonItem) {
        self.navigationController?.dismiss(animated: false, completion: nil)
    }

    @objc func skipButtonPressed(sender: UIBarButtonItem) {

    }
}
