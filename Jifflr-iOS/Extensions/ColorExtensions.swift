//
//  ColorExtensions.swift
//  Ad-M8-iOS
//
//  Created by James Shaw on 09/10/2017.
//  Copyright © 2017 The Distance. All rights reserved.
//

import UIKit

extension UIColor {
    static var mainBlue: UIColor {
        return UIColor(red: 39/255, green: 35/255, blue: 97/255, alpha: 1)
    }

    static var mainBlueTransparent80: UIColor {
        return UIColor(red: 39/255, green: 35/255, blue: 97/255, alpha: 0.8)
    }

    static var mainBlueTransparent40: UIColor {
        return UIColor(red: 39/255, green: 35/255, blue: 97/255, alpha: 0.4)
    }
    
    static var mainBlueTransparent10: UIColor {
        return UIColor(red: 39/255, green: 35/255, blue: 97/255, alpha: 0.1)
    }

    static var mainPink: UIColor {
        return UIColor(red: 198/255, green: 28/255, blue: 141/255, alpha: 1)
    }

    static var mainPinkTransparent50: UIColor {
        return UIColor(red: 198/255, green: 28/255, blue: 141/255, alpha: 0.5)
    }

    static var mainPinkBright: UIColor {
        return UIColor(red: 244/255, green: 38/255, blue: 175/255, alpha: 1)
    }

    static var mainOrange: UIColor {
        return UIColor(red: 244/255, green: 126/255, blue: 32/255, alpha: 1)
    }
    
    static var mainOrangeTransparent50: UIColor {
        return UIColor(red: 244/255, green: 126/255, blue: 32/255, alpha: 0.5)
    }

    static var mainGreen: UIColor {
        return UIColor(red: 148/255, green: 192/255, blue: 61/255, alpha: 1)
    }

    static var mainLightBlue: UIColor {
        return UIColor(red: 74/255, green: 144/255, blue: 226/255, alpha: 1)
    }

    static var mainRed: UIColor {
        return UIColor(red: 255/255, green: 0/255, blue: 31/255, alpha: 1)
    }

    static var mainWhiteTransparent20: UIColor {
        return UIColor(white: 1.0, alpha: 0.2)
    }

    static var mainWhiteTransparent40: UIColor {
        return UIColor(white: 1.0, alpha: 0.4)
    }

    static var mainWhiteTransparent50: UIColor {
        return UIColor(white: 1.0, alpha: 0.5)
    }

    static var mainWhiteTransparent60: UIColor {
        return UIColor(white: 1.0, alpha: 0.5)
    }
    
    static var greyPlaceholderColor: UIColor {
        return UIColor(red: 0.78, green: 0.78, blue: 0.80, alpha: 1.0)
    }
    
    static var offSwitchGrey: UIColor {
        return UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
    }
    
    static var inactiveAdvertGrey: UIColor {
        return UIColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 1.0)
    }
}

extension UIImage {
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}

extension Double {
    func toInt() -> Int {
        if self > Double(Int.min) && self < Double(Int.max) {
            return Int(self)
        } else {
            return 0
        }
    }
    
    func rounded(toPlaces places: Int) -> Double {
        let multiplier = pow(10.0, Double(places))
        return (self * multiplier).rounded() / multiplier
    }
}
