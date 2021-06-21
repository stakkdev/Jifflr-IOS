//
//  TermsAndConditionsViewController.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 12/02/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit
import WebKit

class TermsAndConditionsViewController: BaseViewController {

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var containerView: UIView!

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
        
        self.webView.frame = CGRect(x: 8.0, y: 8.0, width: self.containerView.frame.width - 16.0, height: self.containerView.frame.height - 16.0)

        guard let url = Bundle.main.url(forResource: "TermsOfUse", withExtension: "html") else { return }
        self.webView.loadFileURL(url, allowingReadAccessTo: url)
        let request = URLRequest(url: url)
        self.webView.load(request)
        self.webView.scrollView.setContentOffset(.zero, animated: false)
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

        self.containerView.clipsToBounds = true
        self.containerView.layer.masksToBounds = true
        self.containerView.layer.cornerRadius = 10.0
        
        let webConfiguration = WKWebViewConfiguration()
        self.webView = WKWebView(frame: self.containerView.frame, configuration: webConfiguration)
        self.containerView.addSubview(self.webView)
    }

    func setupLocalization() {
        self.navigationBar.topItem?.title = "termsAndConditions.navigation.title".localized()
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
