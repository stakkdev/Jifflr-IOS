//
//  JifflrTextFieldDate.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 16/04/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit

enum DateType {
    case dateFrom
    case dateTo
    case timeFrom
    case timeTo
}

class JifflrTextFieldDate: JifflrTextField {
    
    var type: DateType = .dateFrom {
        didSet {
            self.setupDate(type: self.type)
            self.createInputViews(type: self.type)
        }
    }
    
    var minimumDate = false
    
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
    
    func setupDate(type: DateType) {
        let daysToAdd = type == .dateFrom ? 2 : 32
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_GB")
        dateFormatter.dateFormat = (type == .dateFrom || type == .dateTo) ? "dd/MM/yyyy" : "HH:mm"
        guard let date = Calendar.current.date(byAdding: .day, value: daysToAdd, to: Date()) else { return }
        let dateString = dateFormatter.string(from: date)
        
        switch type {
        case .dateFrom:
            self.text = dateString
        case .dateTo:
            self.text = dateString
        case .timeFrom:
            self.text = "00:00"
        case .timeTo:
            self.text = "23:45"
        }
    }
    
    func createInputViews(type: DateType) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_GB")
        dateFormatter.dateFormat = (self.type == .dateFrom || self.type == .dateTo) ? "dd/MM/yyyy" : "HH:mm"
        guard let date = dateFormatter.date(from: self.text!) else { return }
        
        self.datePicker = UIDatePicker()
        self.datePicker.date = date
        self.datePicker.datePickerMode = (type == .dateFrom || type == .dateTo) ? .date : .time
        self.datePicker.minuteInterval = 15
        
        if self.minimumDate && self.datePicker.datePickerMode == .date {
            let rightNow = Date()
            let interval = 15
            let nextDiff = interval - Calendar.current.component(.minute, from: rightNow) % interval
            let nextDate = Calendar.current.date(byAdding: .minute, value: nextDiff, to: rightNow) ?? Date()
            
            guard let date = Calendar.current.date(byAdding: .day, value: 1, to: nextDate) else { return }
            self.datePicker.minimumDate = date
        }
        
        self.datePicker.addTarget(self, action: #selector(datePicked), for: .valueChanged)
        self.inputView = self.datePicker
        
        let dateToolbar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: 44.0))
        dateToolbar.barStyle = UIBarStyle.default
        let dateCloseButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.dateCloseButtonPressed))
        let flexibleSpacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        dateToolbar.items = [flexibleSpacer, dateCloseButton]
        self.inputAccessoryView = dateToolbar
    }
    
    @objc func datePicked(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_GB")
        dateFormatter.dateFormat = (self.type == .dateFrom || self.type == .dateTo) ? "dd/MM/yyyy" : "HH:mm"
        self.text = dateFormatter.string(from: sender.date)
    }
    
    @objc func dateCloseButtonPressed() {
        self.datePicked(sender: self.datePicker)
        self.resignFirstResponder()
    }
}
