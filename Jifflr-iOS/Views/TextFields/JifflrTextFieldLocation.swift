//
//  JifflrTextFieldLocation.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 12/02/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit

protocol LocationTextFieldDelegate {
    func gpsPressed()
}

class JifflrTextFieldLocation: JifflrTextField {

    var locationDelegate: LocationTextFieldDelegate?

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

        self.addRightButton(image: UIImage(named: "RegistrationGPS")!, for: self, action: #selector(gpsPressed))

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

    @objc func gpsPressed() {
        self.animate()
        self.locationDelegate?.gpsPressed()
    }

    func animate() {
        guard let rightView = self.rightView else { return }
        rightView.isHidden = true

        self.activity.startAnimating()
    }

    func stopAnimating() {
        guard let rightView = self.rightView else { return }
        rightView.isHidden = false

        self.activity.stopAnimating()
    }
}
