//
//  StringExtensions.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 22/03/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import Foundation

extension String {
    func isEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    func containsNumbers() -> Bool {
        let numbersRange = self.rangeOfCharacter(from: .decimalDigits)
        let hasNumbers = (numbersRange != nil)
        return hasNumbers
    }
    
    func isUrl() -> Bool {
        if let url = URL(string: self) {
            return UIApplication.shared.canOpenURL(url)
        }
        
        return false
    }
}
