//
//  JifflrTextFieldDate.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 16/04/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit

class JifflrTextFieldDate: JifflrTextField {

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
    }
    
    func addLeftImage(image: UIImage) {
        let leftWrapperView = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 50))
        leftWrapperView.backgroundColor = UIColor.mainOrange
        let leftImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 44, height: 50))
        leftImageView.image = image
        leftImageView.contentMode = .center
        leftWrapperView.addSubview(leftImageView)
        self.leftView = leftWrapperView
        self.leftViewMode = .always
    }
    
    func setLeftViewColor(color: UIColor) {
        guard let leftView = self.leftView else { return }
        leftView.backgroundColor = color
    }
}
