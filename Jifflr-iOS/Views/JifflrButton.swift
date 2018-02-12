//
//  JifflrButton.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 09/02/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit

class JifflrButton: UIButton {

    var activity: UIActivityIndicatorView!
    var originalColor: UIColor?

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

        self.activity = UIActivityIndicatorView(activityIndicatorStyle: .white)
        self.activity.translatesAutoresizingMaskIntoConstraints = false
        self.activity.hidesWhenStopped = true
        self.activity.isHidden = true
        self.addSubview(self.activity)

        let horizontalConstraint = NSLayoutConstraint(item: self.activity, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        let verticalConstraint = NSLayoutConstraint(item: self.activity, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        self.addConstraints([horizontalConstraint, verticalConstraint])
    }

    func setBackgroundColor(color: UIColor) {
        self.backgroundColor = color
    }

    func animate() {
        self.originalColor = self.titleColor(for: .normal)
        self.setTitleColor(UIColor.clear, for: .normal)
        self.activity.startAnimating()
    }

    func stopAnimating() {
        self.activity.stopAnimating()

        if let color = self.originalColor {
            self.setTitleColor(color, for: .normal)
        }
    }
}
