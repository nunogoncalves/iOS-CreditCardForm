//
//  Date.swift
//  CreditCard
//
//  Created by Nuno Gonçalves on 14/11/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

import Foundation

fileprivate let calendar = Calendar(identifier: .gregorian)

extension Date {
    
    func beginningOfMonth() -> Date {
            var components = calendar.dateComponents([.year, .month, .day], from: self)
            components.day = 1
            return calendar.date(from: components)!
    }

    func endOfMonth() -> Date {
        var components = calendar.dateComponents([.year, .month, .day], from: self)
        components.day = 1
        components.month! = components.month! + 1
        let date = calendar.date(from: components)
        return (calendar as NSCalendar).date(byAdding: .day, value: -1, to: date!, options: [])!
    }
    
}
