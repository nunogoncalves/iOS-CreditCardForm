//
//  UIStackView.swift
//  CreditCard
//
//  Created by Nuno Gonçalves on 11/11/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

import UIKit

public extension UIStackView {
    
    public func addArrangedSubviews(_ views: [UIView]) {
        views.forEach { addArrangedSubview($0) }
    }
    
}
