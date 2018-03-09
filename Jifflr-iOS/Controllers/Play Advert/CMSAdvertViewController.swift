//
//  CMSAdvertViewController.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 09/03/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit

class CMSAdvertViewController: BaseViewController {

    var advert: Advert!

    class func instantiateFromStoryboard(advert: Advert) -> CMSAdvertViewController {
        let storyboard = UIStoryboard(name: "Advert", bundle: nil)
        let advertViewController = storyboard.instantiateViewController(withIdentifier: "CMSAdvertViewController") as! CMSAdvertViewController
        advertViewController.advert = advert
        return advertViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
    }

    func setupUI() {
        self.setupLocalization()
        self.setBackgroundImage(image: UIImage(named: "MainBackground"))
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    func setupLocalization() { }

    @IBAction func showFeedback(sender: UIButton) {
        // TODO: Switch on QuestionType
        self.navigationController?.pushViewController(DateTimeFeedbackViewController.instantiateFromStoryboard(advert: self.advert), animated: true)
    }
}
