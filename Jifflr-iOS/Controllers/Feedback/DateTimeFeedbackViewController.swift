//
//  DateTimeFeedbackViewController.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 09/03/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit

class DateTimeFeedbackViewController: FeedbackViewController {

    @IBOutlet weak var datePicker: UIDatePicker!

    class func instantiateFromStoryboard(advert: Advert) -> DateTimeFeedbackViewController {
        let storyboard = UIStoryboard(name: "Advert", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "DateTimeFeedbackViewController") as! DateTimeFeedbackViewController
        controller.advert = advert
        return controller
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.datePicker.setValue(UIColor.white, forKey: "textColor")
        self.datePicker.setValue(false, forKey: "highlightsToday")

        //self.datePicker.datePickerMode = .date

        self.datePicker.datePickerMode = .time
    }

    override func validateAnswers() -> Bool {
        return true
    }
}
