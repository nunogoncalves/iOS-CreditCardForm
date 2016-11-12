//
//  CreditCardFormType.swift
//  CreditCard
//
//  Created by Nuno Gonçalves on 12/11/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

import UIKit

enum FormItemType: String {
    
    case name = "Card Name"
    case number = "Card Number"
    case securityCode = "CVV/CVC"
    case expiryDate = "Expiry Date"
        
    var maxLength: Int? {
        switch self {
        case .number: return 16
        case .securityCode: return 3
        case .name, .expiryDate: return nil
        }
    }
    
    var textFieldRequiredWidth: Int {
        switch self {
        case .number: return 180
        case .securityCode: return 70
        case .name: return 250
        case .expiryDate: return 100
        }
    }

    var keyboardType: UIKeyboardType {
        switch self {
        case .number: return .numberPad
        case .securityCode: return .numberPad
        case .name, .expiryDate: return .default
        }
    }

}
