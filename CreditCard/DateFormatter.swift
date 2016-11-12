//
//  DateFormatter.swift
//  CreditCard
//
//  Created by Nuno Gonçalves on 11/11/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

import Foundation

public extension DateFormatter {
    
    public convenience init(format: String) {
        self.init()
        dateFormat = format
    }
    
}
