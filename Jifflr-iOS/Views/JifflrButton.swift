//
//  JifflrButton.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 09/02/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit

class JifflrButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.commonInit()
    }

    func commonInit() {
        self.titleLabel?.font = UIFont(name: Constants.FontNames.GothamBold, size: 20.0)
        self.setTitleColor(UIColor.white, for: .normal)

        self.clipsToBounds = true
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 12.0
    }

    func setBackgroundColor(color: UIColor) {
        self.backgroundColor = color
    }
}
