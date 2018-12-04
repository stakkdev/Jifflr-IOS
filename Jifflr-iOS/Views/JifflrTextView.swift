//
//  JifflrTextView.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 27/03/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit

class JifflrTextView: UITextView {
    
    var placeholder = "" {
        didSet {
            self.text = self.placeholder
        }
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.commonInit()
    }
    
    func commonInit() {
        self.font = UIFont(name: Constants.FontNames.GothamBook, size: 20.0)
        self.textColor = UIColor.greyPlaceholderColor
        self.backgroundColor = UIColor.white
        
        self.clipsToBounds = true
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 12.0
        self.textContainerInset = UIEdgeInsets(top: 12, left: 8, bottom: 12, right: 8)
        self.delegate = self
    }
}

extension JifflrTextView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.greyPlaceholderColor {
            textView.text = nil
            textView.textColor = UIColor.mainBlue
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = self.placeholder
            textView.textColor = UIColor.greyPlaceholderColor
        }
    }
}
