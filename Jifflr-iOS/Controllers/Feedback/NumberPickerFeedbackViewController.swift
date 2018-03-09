//
//  NumberPickerFeedbackViewController.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 09/03/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit

class NumberPickerFeedbackViewController: FeedbackViewController {

    @IBOutlet weak var pickerView: UIPickerView!

    var numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

    class func instantiateFromStoryboard(advert: Advert) -> NumberPickerFeedbackViewController {
        let storyboard = UIStoryboard(name: "Advert", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "NumberPickerFeedbackViewController") as! NumberPickerFeedbackViewController
        controller.advert = advert
        return controller
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.pickerView.delegate = self
        self.pickerView.dataSource = self
    }

    override func validateAnswers() -> Bool {
        return true
    }
}

extension NumberPickerFeedbackViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.numbers.count
    }

    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let answer = numbers[row]
        let font = UIFont(name: Constants.FontNames.GothamBook, size: 20.0)!
        let attributes = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: font]
        let attributedString = NSAttributedString(string: "\(answer)", attributes: attributes)
        return attributedString
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

    }
}
