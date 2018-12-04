//
//  ScaleButton.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 05/03/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit

class ScaleButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.commonInit()
    }

    func commonInit() { }

    func setButton(on: Bool, scale: Int) {
        if on {
            self.tag = 1
            self.setImage(UIImage(named: "FeedbackScale\(scale)Selected"), for: .normal)
        } else {
            self.tag = 0
            self.setImage(UIImage(named: "FeedbackScale\(scale)"), for: .normal)
        }
    }
}
