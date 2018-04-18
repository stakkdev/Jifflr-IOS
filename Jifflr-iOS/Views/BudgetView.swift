//
//  BudgetView.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 18/04/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit

class BudgetView: UIView {
    
    var value = 0.00 {
        didSet {
            let valueString = String(format: "%.2f", self.value)
            self.label.text = "£\(valueString)"
        }
    }
    
    var subtractButton: UIButton!
    var addButton: UIButton!
    var label: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.commonInit()
    }
    
    func commonInit() {
        self.setupUI()
        self.setupConstraints()
    }
    
    func setupUI() {
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 12.0
        self.layer.masksToBounds = true
        self.clipsToBounds = true
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.subtractButton = UIButton(type: .custom)
        self.subtractButton.backgroundColor = UIColor.mainOrange
        self.subtractButton.setImage(UIImage(named: "BudgetButtonSubtract"), for: .normal)
        self.subtractButton.addTarget(self, action: #selector(self.subtractButtonPressed(sender:)), for: .touchUpInside)
        self.subtractButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.subtractButton)
        
        self.addButton = UIButton(type: .custom)
        self.addButton.backgroundColor = UIColor.mainOrange
        self.addButton.setImage(UIImage(named: "BudgetButtonAdd"), for: .normal)
        self.addButton.addTarget(self, action: #selector(self.addButtonPressed(sender:)), for: .touchUpInside)
        self.addButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.addButton)
        
        self.label = UILabel()
        self.label.font = UIFont(name: Constants.FontNames.GothamBook, size: 20.0)
        self.label.textColor = UIColor.mainBlue
        self.label.translatesAutoresizingMaskIntoConstraints = false
        self.label.textAlignment = .center
        self.addSubview(self.label)
        self.value = 10.00
    }
    
    func setupConstraints() {
        let subButtonLeading = NSLayoutConstraint(item: self.subtractButton, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        let subButtonWidth = NSLayoutConstraint(item: self.subtractButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 46)
        let subButtonBottom = NSLayoutConstraint(item: self.subtractButton, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        let subButtonTop = NSLayoutConstraint(item: self.subtractButton, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        self.addConstraints([subButtonLeading, subButtonWidth, subButtonBottom, subButtonTop])
        
        let addButtonTrailing = NSLayoutConstraint(item: self.addButton, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
        let addButtonWidth = NSLayoutConstraint(item: self.addButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 46)
        let addButtonBottom = NSLayoutConstraint(item: self.addButton, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        let addButtonTop = NSLayoutConstraint(item: self.addButton, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        self.addConstraints([addButtonTrailing, addButtonWidth, addButtonBottom, addButtonTop])
        
        let labelTrailing = NSLayoutConstraint(item: self.label, attribute: .trailing, relatedBy: .equal, toItem: self.addButton, attribute: .leading, multiplier: 1, constant: 0)
        let labelLeading = NSLayoutConstraint(item: self.label, attribute: .leading, relatedBy: .equal, toItem: self.subtractButton, attribute: .trailing, multiplier: 1, constant: 0)
        let labelBottom = NSLayoutConstraint(item: self.label, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        let labelTop = NSLayoutConstraint(item: self.label, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        self.addConstraints([labelTrailing, labelLeading, labelBottom, labelTop])
    }
    
    @objc func subtractButtonPressed(sender: UIButton) {
        guard self.value > 1.0 else { return }
        self.value -= 1.0
    }
    
    @objc func addButtonPressed(sender: UIButton) {
        self.value += 1.0
    }
}
