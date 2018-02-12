//
//  JifflrTextFieldPassword.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 09/02/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit

class JifflrTextFieldPassword: JifflrTextField {

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

        self.isSecureTextEntry = true
        self.addRightButton(image: UIImage(named: "PasswordEyeVisible")!, for: self, action: #selector(toggleSecureTextEntry))
    }

    func addRightButton(image: UIImage, for target: Any?, action: Selector?) {
        let rightWrapperView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        let rightButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))

        rightButton.setImage(image, for: .normal)

        if let target = target, let action = action {
            rightButton.addTarget(target, action: action, for: .touchUpInside)
        } else {
            rightButton.addTarget(self, action: #selector(becomeFirstResponder), for: .touchUpInside)
        }

        rightWrapperView.addSubview(rightButton)
        self.rightView = rightWrapperView
        self.rightViewMode = .always
    }

    @objc func toggleSecureTextEntry() {

        guard let rightView = self.rightView else { return }

        var image = UIImage(named: "PasswordEyeVisible")
        if self.isSecureTextEntry == true {
            image = UIImage(named: "PasswordEyeHidden")
        }

        self.isSecureTextEntry = !self.isSecureTextEntry

        for subview in rightView.subviews {
            if let button = subview as? UIButton {
                button.setImage(image, for: .normal)
                return
            }
        }
    }
}
