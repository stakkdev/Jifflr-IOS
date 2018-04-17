//
//  GenderSegmentedControl.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 16/04/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit

class GenderSegmentedControl: UISegmentedControl {
    
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
    }
    
    func setupUI() {
        self.layer.cornerRadius = 12.0
        self.layer.masksToBounds = true
        self.clipsToBounds = true
        self.tintColor = UIColor.mainOrange
        self.backgroundColor = UIColor.white
        
        let unselectedAttributes = [
            NSAttributedStringKey.foregroundColor: UIColor.mainBlue,
            NSAttributedStringKey.font:  UIFont(name: Constants.FontNames.GothamBook, size: 20.0)!
        ]
        
        let selectedAttributes = [
            NSAttributedStringKey.foregroundColor: UIColor.white,
            NSAttributedStringKey.font:  UIFont(name: Constants.FontNames.GothamBold, size: 20.0)!
        ]
        
        self.setTitleTextAttributes(unselectedAttributes, for: .normal)
        self.setTitleTextAttributes(selectedAttributes, for: .selected)
        
        self.setTitle("createTarget.gender.male".localized(), forSegmentAt: 0)
        self.setTitle("createTarget.gender.female".localized(), forSegmentAt: 1)
        self.setTitle("createTarget.gender.all".localized(), forSegmentAt: 2)
        
        self.setBackgroundImage(UIImage(color: self.backgroundColor!), for: .normal, barMetrics: .default)
        self.setBackgroundImage(UIImage(color: self.tintColor!), for: .selected, barMetrics: .default)
        self.setDividerImage(UIImage(color: UIColor.mainBlue)!, forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
    }
}
