//
//  JifflrTextFieldDropdown.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 03/04/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit

class JifflrTextFieldDropdown: JifflrTextField {
    
    var questionType: QuestionType? {
        didSet {
            if let questionType = self.questionType {
                self.text = questionType.name
                self.setRightViewColor(color: UIColor.mainOrange)
            } else {
                self.text = ""
                self.setRightViewColor(color: UIColor.mainBlueTransparent10)
            }
        }
    }

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
    
    func setRightViewColor(color: UIColor) {
        guard let rightView = self.rightView else { return }
        rightView.backgroundColor = color
    }
}
