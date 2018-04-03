//
//  JifflrTextFieldDropdown.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 03/04/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit

class JifflrTextFieldDropdown: JifflrTextField {

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
        
        self.addRightImage(image: UIImage(named: "AnswerDropdown")!)
    }
    
    func addRightImage(image: UIImage) {
        let rightWrapperView = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 50))
        rightWrapperView.backgroundColor = UIColor.mainOrange
        let rightImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 44, height: 50))
        rightImageView.image = image
        rightImageView.contentMode = .center
        rightWrapperView.addSubview(rightImageView)
        self.rightView = rightWrapperView
        self.rightViewMode = .always
    }
}
