//
//  CreditCartType.swift
//  CreditCard
//
//  Created by Nuno Gonçalves on 12/11/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

import Foundation
import UIKit

enum CreditCardType : String {
    
    case visa = "Visa"
    case visaElectron = "Visa Electron"
    case mastercard = "Mastercard"
    case maestro = "Maestro"
    case americanExpress = "American Express"
    case dinnersClub = "Dinners Club"
    case discovery = "Discovery"
    case jcb = "JCB"
    
    static var all: [CreditCardType] {
        return [
            .visa,
            .visaElectron,
            .mastercard,
            .maestro,
            .americanExpress,
            .dinnersClub,
            .discovery,
            .jcb
        ]
    }
    
    var pattern: String {
        switch self {
        case .visa: return "^4[0-9]{12}(?:[0-9]{3})?$"
        case .visaElectron: return "^(4026|417500|4508|4844|491(3|7))"
        case .mastercard: return "^5[1-5][0-9]{14}$"
        case .maestro: return "^(5018|5020|5038|6304|6759|676[1-3])"
        case .americanExpress: return "^3[47][0-9]{13}$"
        case .dinnersClub: return "^3(?:0[0-5]|[68][0-9])[0-9]{11}$"
        case .discovery: return "^6(?:011|5[0-9]{2})[0-9]{12}$"
        case .jcb: return "^(?:2131|1800|35\\d{3})\\d{11}$"
        }
    }
    
    var backgroundImage: UIImage {
        switch self {
        case .visa, .visaElectron: return #imageLiteral(resourceName: "creditcardfrontblue")
        case .mastercard, .maestro, .americanExpress: return #imageLiteral(resourceName: "creditcardfrontgreen")
        case .dinnersClub, .discovery, .jcb: return #imageLiteral(resourceName: "creditcardfrontpurple")
        }
    }
    
    var image: UIImage {
        switch self {
        case .visa: return #imageLiteral(resourceName: "visa")
        case .visaElectron: return #imageLiteral(resourceName: "visaelectron")
        case .mastercard: return #imageLiteral(resourceName: "mastercard")
        case .maestro: return #imageLiteral(resourceName: "maestro")
        case .americanExpress: return #imageLiteral(resourceName: "americanexpress")
        case .dinnersClub: return #imageLiteral(resourceName: "dinnersclub")
        case .discovery: return #imageLiteral(resourceName: "discover")
        case .jcb: return #imageLiteral(resourceName: "jcb")
        }
    }
    
    var exampleValue: String {
        switch self {
        case .visa: return "4111111111111111"
        case .visaElectron: return "4026 0000 0000 0002"
        case .mastercard: return "5538 3838 8383 3838"
        case .maestro: return "5018 0000 0009"
        case .americanExpress: return "3470 0000 0000 000"
        case .dinnersClub: return "3009 9999 9999 99"
        case .discovery: return "6550 0000 0000 0000"
        case .jcb: return "1800 0000 0000 000"
        }
    }
}
