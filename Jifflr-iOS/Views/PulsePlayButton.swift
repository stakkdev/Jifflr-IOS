//
//  PulsePlayButton.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 14/02/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit

class PulsePlayButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.commonInit()
    }

    func commonInit() { }

    func pulse() {
        CATransaction.begin()
        CATransaction.setCompletionBlock({

        })

        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.duration = 0.2
        animation.repeatCount = 1
        animation.autoreverses = true
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.fromValue = 1.0
        animation.toValue = 1.3
        self.layer.add(animation, forKey: "scale")

        CATransaction.commit()
    }
}
