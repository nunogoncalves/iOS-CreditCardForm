//
//  UIColor.swift
//  CreditCard
//
//  Created by Nuno Gonçalves on 11/11/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(hex: UInt, alpha: CGFloat = 1.0) {
        self.init(red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
                  blue:  CGFloat(hex & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
    
    static var keyboardButton: UIColor {
        return UIColor(hex: 0x20C055)
    }
    
    static var veryLightGray: UIColor {
        return UIColor(hex: 0xEBEBF1)
    }

    
}
