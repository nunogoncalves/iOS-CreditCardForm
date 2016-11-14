//
//  CreditCardFormDelegate.swift
//  CreditCard
//
//  Created by Nuno Gonçalves on 14/11/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

protocol CreditCardFormDelegate : class {
    func updated(cardNumber: String)
    func updated(cardName: String)
    func updated(cardSecurityCode: String)
    func updated(cardExpiryDate: String)
    func selected(_ type: InputType)
}
