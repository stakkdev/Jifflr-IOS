//
//  CMSAdvertViewController.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 09/03/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit

class CMSAdvertViewController: BaseViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleBackgroundView: UIView!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var imageView: UIImageView!

    var advert: Advert!
    var isPreview = false
    var content:[(question: Question, answers: [Answer])] = []

    class func instantiateFromStoryboard(advert: Advert, isPreview: Bool) -> CMSAdvertViewController {
        let storyboard = UIStoryboard(name: "Advert", bundle: nil)
        let advertViewController = storyboard.instantiateViewController(withIdentifier: "CMSAdvertViewController") as! CMSAdvertViewController
        advertViewController.advert = advert
        advertViewController.isPreview = isPreview
        return advertViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
        self.setupData()
        
        if !self.isPreview {
            self.fetchData()
        }
        
        self.messageTextView.text = "Quiz night\nEvery Tuesday Evening\nStarts: 8pm"
        self.titleLabel.text = "THE RED LION"
    }

    func setupUI() {
        self.setupLocalization()
        self.setupConstraints()
        
        self.setBackgroundImage(image: UIImage(named: "MainBackground"))
        self.navigationController?.isNavigationBarHidden = false
        
        if self.isPreview {
            let dismissBarButton = UIBarButtonItem(image: UIImage(named: "NavigationDismiss"), style: .plain, target: self, action: #selector(self.dismissButtonPressed(sender:)))
            self.navigationItem.leftBarButtonItem = dismissBarButton
        } else {
            let flagBarButton = UIBarButtonItem(image: UIImage(named: "FlagAdButton"), style: .plain, target: self, action: #selector(self.flagButtonPressed(sender:)))
            self.navigationItem.rightBarButtonItem = flagBarButton
        }
    }
    
    func setupData() {
        self.titleLabel.text = self.advert.details?.title
        self.messageTextView.text = self.advert.details?.message
        
        self.advert.details?.image?.getDataInBackground(block: { (data, error) in
            guard let data = data, error == nil else { return }
            self.imageView.image = UIImage(data: data)
        })
    }

    func setupLocalization() {
        if self.isPreview {
            self.title = "adPreview.navigation.title".localized()
        }
    }
    
    func fetchData() {
        AdvertManager.shared.fetchLocalQuestionsAndAnswers(advert: self.advert) { (content) in
            guard content.count > 0 else { return }
            self.content = content
        }
    }

    func showFeedback() {
        guard let question = self.content.first?.question else { return }
        
        var controller: UIViewController!
        
        switch question.type.type {
        case AdvertQuestionType.Binary:
            controller = BinaryFeedbackViewController.instantiateFromStoryboard(advert: self.advert, content: self.content, questionAnswers: [])
        case AdvertQuestionType.DatePicker:
            controller = DateTimeFeedbackViewController.instantiateFromStoryboard(advert: self.advert, content: self.content, questionAnswers: [], isTime: false)
        case AdvertQuestionType.MultiSelect:
            controller = MultiSelectFeedbackViewController.instantiateFromStoryboard(advert: self.advert, content: self.content, questionAnswers: [])
        case AdvertQuestionType.NumberPicker:
            controller = NumberPickerFeedbackViewController.instantiateFromStoryboard(advert: self.advert, content: self.content, questionAnswers: [])
        case AdvertQuestionType.Scale:
            controller = ScaleFeedbackViewController.instantiateFromStoryboard(advert: self.advert, content: self.content, questionAnswers: [])
        case AdvertQuestionType.TimePicker:
            controller = DateTimeFeedbackViewController.instantiateFromStoryboard(advert: self.advert, content: self.content, questionAnswers: [], isTime: true)
        default:
            controller = BinaryFeedbackViewController.instantiateFromStoryboard(advert: self.advert, content: self.content, questionAnswers: [])
        }
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func dismissButtonPressed(sender: UIBarButtonItem) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func flagButtonPressed(sender: UIBarButtonItem) {
        self.showFeedback()
    }
}
