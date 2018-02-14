//
//  TermsAndConditionsViewController.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 12/02/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit

class TermsAndConditionsViewController: BaseViewController {

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var textView: UITextView!

    class func instantiateFromStoryboard() -> TermsAndConditionsViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "TermsAndConditionsViewController") as! TermsAndConditionsViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        self.textView.setContentOffset(.zero, animated: false)
    }

    func setupUI() {
        self.setupLocalization()
        self.setBackgroundImage(image: UIImage(named: "MainBackground"))

        self.navigationBar.delegate = self
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = true
        let font = UIFont(name: Constants.FontNames.GothamBold, size: 18.0)!
        self.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: font, NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationBar.tintColor = UIColor.white

        let dismissBarButton = UIBarButtonItem(image: UIImage(named: "NavigationDismiss"), style: .plain, target: self, action: #selector(self.dismissButtonPressed(sender:)))
        self.navigationBar.topItem?.rightBarButtonItem = dismissBarButton

        self.textView.clipsToBounds = true
        self.textView.layer.masksToBounds = true
        self.textView.layer.cornerRadius = 10.0
        self.textView.textContainerInset = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
    }

    func setupLocalization() {
        self.navigationBar.topItem?.title = "termsAndConditions.navigation.title".localized()
        self.textView.text = "termsAndConditions.content".localized()
    }

    @objc func dismissButtonPressed(sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension TermsAndConditionsViewController: UINavigationBarDelegate {
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}
