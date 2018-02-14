//
//  JifflrTextField.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 09/02/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit

class JifflrTextField: UITextField {

    let insets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.commonInit()
    }

    func commonInit() {
        self.font = UIFont(name: Constants.FontNames.GothamBook, size: 20.0)
        self.textColor = UIColor.mainBlue
        self.borderStyle = .none
        self.backgroundColor = UIColor.white

        self.clipsToBounds = true
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 12.0
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, self.insets)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, self.insets)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, self.insets)
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
}
