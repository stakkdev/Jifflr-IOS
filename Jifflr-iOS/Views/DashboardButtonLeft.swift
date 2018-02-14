//
//  DashboardButton.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 14/02/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit

class DashboardButtonLeft: UIButton {

    var iconImageView: UIImageView!

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.commonInit()
    }

    func commonInit() {
        self.clipsToBounds = true
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 20.0

        self.setTitle("", for: .normal)
    }

    func setBackgroundColor(color: UIColor) {
        self.backgroundColor = color
    }
}
