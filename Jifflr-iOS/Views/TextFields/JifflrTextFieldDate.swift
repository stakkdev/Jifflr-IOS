//
//  JifflrTextFieldDate.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 16/04/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit

class JifflrTextFieldDate: JifflrTextField {
    
    var dateFormat = "" {
        didSet {
            self.setupDate(format: self.dateFormat)
            self.createInputViews(format: self.dateFormat)
        }
    }
    
    var datePicker: UIDatePicker!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.commonInit()
    }
    
    override func commonInit() {
        super.commonInit()
        
        self.insets = UIEdgeInsets(top: 0, left: 56, bottom: 0, right: 0)
        self.adjustsFontSizeToFitWidth = true
    }
    
    func addLeftImage(image: UIImage) {
        let leftWrapperView = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 50))
        leftWrapperView.backgroundColor = UIColor.mainOrange
        let leftImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 44, height: 50))
        leftImageView.image = image
        leftImageView.contentMode = .center
        leftWrapperView.addSubview(leftImageView)
        self.leftView = leftWrapperView
        self.leftViewMode = .always
    }
    
    func setLeftViewColor(color: UIColor) {
        guard let leftView = self.leftView else { return }
        leftView.backgroundColor = color
    }
    
    func setupDate(format: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        guard let date = Calendar.current.date(byAdding: .day, value: 1, to: Date()) else { return }
        let dateString = dateFormatter.string(from: date)
        self.text = dateString
    }
    
    func createInputViews(format: String) {
        guard let date = Calendar.current.date(byAdding: .day, value: 1, to: Date()) else { return }
        self.datePicker = UIDatePicker()
        self.datePicker.date = date
        self.datePicker.datePickerMode = format == "HH:mm" ? .time : .date
        self.datePicker.minimumDate = date
        self.datePicker.addTarget(self, action: #selector(datePicked), for: .valueChanged)
        self.inputView = self.datePicker
        
        let dateToolbar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: 44.0))
        dateToolbar.barStyle = UIBarStyle.default
        let dateCloseButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.dateCloseButtonPressed))
        dateToolbar.items = [dateCloseButton]
        self.inputAccessoryView = dateToolbar
    }
    
    @objc func datePicked(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = self.dateFormat
        self.text = dateFormatter.string(from: sender.date)
    }
    
    @objc func dateCloseButtonPressed() {
        self.datePicked(sender: self.datePicker)
        self.resignFirstResponder()
    }
}
