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
        
        self.insets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 56)
        
        self.addRightImage(image: UIImage(named: "AnswerDropdown")!)
        
        self.activity = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        self.activity.translatesAutoresizingMaskIntoConstraints = false
        self.activity.hidesWhenStopped = true
        self.activity.isHidden = true
        self.activity.tintColor = UIColor.mainBlue
        self.addSubview(self.activity)
        
        let trailingConstraint = NSLayoutConstraint(item: self.activity, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 15)
        let verticalConstraint = NSLayoutConstraint(item: self.activity, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        self.addConstraints([trailingConstraint, verticalConstraint])
    }
    
    func addRightImage(image: UIImage) {
        let rightWrapperView = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 50))
        rightWrapperView.backgroundColor = UIColor.mainOrange
        let rightImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 44, height: 50))
        rightImageView.image = image
        rightImageView.contentMode = .center
        rightImageView.isUserInteractionEnabled = true
        rightWrapperView.addSubview(rightImageView)
        rightWrapperView.isUserInteractionEnabled = true
        self.rightView = rightWrapperView
        self.rightView?.isUserInteractionEnabled = true
        self.rightViewMode = .always
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(rightViewTapped))
        self.rightView?.addGestureRecognizer(tapGesture)
    }
    
    @objc func rightViewTapped() {
        self.becomeFirstResponder()
    }
    
    func setRightViewColor(color: UIColor) {
        guard let rightView = self.rightView else { return }
        rightView.backgroundColor = color
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
