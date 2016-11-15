//
//  CreditCardTypeChecker.swift
//  CreditCard
//
//  Created by Nuno Gonçalves on 12/11/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

import Foundation

struct CreditCardTypeChecker {
    
    static func type(for value: String) -> CreditCardType? {
        for creditCardType in CreditCardType.all {
            if isValid(for: creditCardType, value: value) {
                return creditCardType
            }
        }
        return nil
    }
    
    private static func isValid(for cardType: CreditCardType, value: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: cardType.pattern,
                                                options: .caseInsensitive)
        
            return regex.matches(in: value,
                                 options: [],
                                 range: NSMakeRange(0, value.characters.count)).count > 0
        } catch {
            return false
        }
    }
}

