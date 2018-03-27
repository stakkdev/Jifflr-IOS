//
//  JifflrTextView.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 27/03/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit

class JifflrTextView: UITextView {
    
    var placeholder = ""
    
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
        self.textColor = UIColor.mainBlue
        self.backgroundColor = UIColor.white
        
        self.clipsToBounds = true
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 12.0
        self.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
    }
}
