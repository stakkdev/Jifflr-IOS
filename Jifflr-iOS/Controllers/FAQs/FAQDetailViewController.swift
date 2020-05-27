//
//  FAQDetailViewController.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 19/02/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit

class FAQDetailViewController: BaseViewController {

    @IBOutlet weak var textView: UITextView!

    var faq: FAQ!

    class func instantiateFromStoryboard() -> FAQDetailViewController {
        let storyboard = UIStoryboard(name: "FAQs", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "FAQDetailViewController") as! FAQDetailViewController
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
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.setHidesBackButton(false, animated: false)
        
        self.textView.backgroundColor = .white
        self.textView.clipsToBounds = true
        self.textView.layer.masksToBounds = true
        self.textView.layer.cornerRadius = 10.0
        self.textView.textContainerInset = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
        self.textView.attributedText = self.setupAttributedText()
    }

    func setupLocalization() {
        self.title = "faqsDetail.navigation.title".localized()
    }

    func setupAttributedText() -> NSMutableAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        paragraphStyle.lineHeightMultiple = 1.1
        let bookFont = UIFont(name: Constants.FontNames.GothamBook, size: 16.0)!
        let attributes = [NSAttributedStringKey.font: bookFont, NSAttributedStringKey.foregroundColor: UIColor.mainBlue, NSAttributedStringKey.paragraphStyle: paragraphStyle]
        let text = "\(self.faq.title)\n\n\(self.faq.descriptionText)"
        let attributedString = NSMutableAttributedString(string: text, attributes: attributes)

        let range = (text as NSString).range(of: self.faq.title)
        if range.location != NSNotFound {
            let boldFont = UIFont(name: Constants.FontNames.GothamBold, size: 20)!
            attributedString.addAttribute(NSAttributedStringKey.font, value: boldFont, range: range)
        }

        return attributedString
    }
}
