//
//  CreditCardFormItemView.swift
//  CreditCard
//
//  Created by Nuno Gonçalves on 12/11/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

import UIKit

extension UIControlEvents {
    static var becameFirstResponder: UIControlEvents {
        return UIControlEvents(rawValue: 0x02000000)
    }
}

class FormItemView : UIControl {
    
    let type: FormItemType
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle(self.type.rawValue.uppercased(), for: .normal)
        button.contentHorizontalAlignment = .left
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        
        
        button.addTarget(self, action: #selector(buttonTap), for: .touchUpInside)
        return button
    }()
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.keyboardType = self.type.keyboardType
        textField.spellCheckingType = .no
        textField.autocorrectionType = .no
        
        textField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        
        textField.textColor = .lightGray
        
        textField.delegate = self
        return textField
    }()
    
    lazy var bottomLine: UIView = {
        let line = UIView()
        return line
    }()
    
    var isActive = false {
        didSet {
            let colorForState: UIColor = isActive ? .darkGray : .lightGray
            button.setTitleColor(colorForState, for: .normal)
            textField.textColor = colorForState
            bottomLine.backgroundColor = .lightGray
        }
    }
    
    init(type: FormItemType) {
        self.type = type
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        isActive = false
        
        addSubview(button)
        addSubview(textField)
        addSubview(bottomLine)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        bottomLine.translatesAutoresizingMaskIntoConstraints = false
        
        button.topAnchor.constraint(equalTo: topAnchor).isActive = true
        button.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        textField.topAnchor.constraint(equalTo: button.bottomAnchor).isActive = true
        textField.leadingAnchor.constraint(equalTo: button.leadingAnchor).isActive = true
        textField.trailingAnchor.constraint(equalTo: button.trailingAnchor).isActive = true
        textField.bottomAnchor.constraint(equalTo: bottomLine.topAnchor).isActive = true
     
        bottomLine.leadingAnchor.constraint(equalTo: textField.leadingAnchor).isActive = true
        bottomLine.trailingAnchor.constraint(equalTo: textField.trailingAnchor).isActive = true
        bottomLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    @objc private func buttonTap() {
        sendActions(for: .becameFirstResponder)
    }
    
    @objc private func editingChanged() {
        sendActions(for: .valueChanged)
    }
}

extension FormItemView : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        sendActions(for: .becameFirstResponder)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentCount = textField.text?.characters.count ?? 0
        
        guard let maxLenght = type.maxLength,
            currentCount != 0 else {
                return true
        }
        
        if (range.length + range.location > currentCount) {
            return false
        }
        let newLength = currentCount + string.characters.count - range.length
        return newLength <= maxLenght
    }
    
    
    
}
