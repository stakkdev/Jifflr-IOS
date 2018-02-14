//
//  JifflrTextFieldSelection.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 12/02/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit

class JifflrTextFieldSelection: JifflrTextField {

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

        self.addRightImage(image: UIImage(named: "RegistrationChevron")!)
    }

    func addRightImage(image: UIImage) {
        let rightWrapperView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        let rightImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        rightImageView.image = image
        rightImageView.contentMode = .center
        rightWrapperView.addSubview(rightImageView)
        self.rightView = rightWrapperView
        self.rightViewMode = .always
    }
}
