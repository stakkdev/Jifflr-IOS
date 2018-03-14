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
    var content:[(question: Question, answers: [Answer])] = []

    class func instantiateFromStoryboard(advert: Advert) -> CMSAdvertViewController {
        let storyboard = UIStoryboard(name: "Advert", bundle: nil)
        let advertViewController = storyboard.instantiateViewController(withIdentifier: "CMSAdvertViewController") as! CMSAdvertViewController
        advertViewController.advert = advert
        return advertViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
        self.fetchData()
    }

    func setupUI() {
        self.setupLocalization()
        self.setBackgroundImage(image: UIImage(named: "MainBackground"))
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    func setupLocalization() { }
    
    func fetchData() {
        AdvertManager.shared.fetchLocalQuestionsAndAnswers(advert: self.advert) { (content) in
            guard content.count > 0 else { return }
            self.content = content
        }
    }

    @IBAction func showFeedback(sender: UIButton) {
        guard let question = self.content.first?.question else { return }
        
        var controller: UIViewController!
        
        switch question.type.type {
        case AdvertQuestionType.Binary:
            controller = BinaryFeedbackViewController.instantiateFromStoryboard(advert: self.advert, content: self.content, questionAnswers: [])
        case AdvertQuestionType.DatePicker:
            controller = DateTimeFeedbackViewController.instantiateFromStoryboard(advert: self.advert)
        case AdvertQuestionType.MultiSelect:
            controller = MultiSelectFeedbackViewController.instantiateFromStoryboard(advert: self.advert)
        case AdvertQuestionType.NumberPicker:
            controller = NumberPickerFeedbackViewController.instantiateFromStoryboard(advert: self.advert)
        case AdvertQuestionType.Scale:
            controller = ScaleFeedbackViewController.instantiateFromStoryboard(advert: self.advert, content: self.content, questionAnswers: [])
        case AdvertQuestionType.TimePicker:
            controller = DateTimeFeedbackViewController.instantiateFromStoryboard(advert: self.advert)
        default:
            controller = BinaryFeedbackViewController.instantiateFromStoryboard(advert: self.advert, content: self.content, questionAnswers: [])
        }
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
