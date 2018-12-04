//
//  JifflrTextFieldInvitation.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 13/02/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit

class JifflrTextFieldInvitation: JifflrTextField {

    var activity: UIActivityIndicatorView!

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

        self.activity = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        self.activity.translatesAutoresizingMaskIntoConstraints = false
        self.activity.hidesWhenStopped = true
        self.activity.isHidden = true
        self.activity.tintColor = UIColor.mainBlue
        self.addSubview(self.activity)

        let trailingConstraint = NSLayoutConstraint(item: self.activity, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -15)
        let verticalConstraint = NSLayoutConstraint(item: self.activity, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        self.addConstraints([trailingConstraint, verticalConstraint])
    }

    func animate() {
        self.activity.startAnimating()
    }

    func stopAnimating() {
        self.activity.stopAnimating()
    }

}
