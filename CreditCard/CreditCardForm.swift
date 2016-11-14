//
//  ScrollableCardItemsForm.swift
//  CreditCard
//
//  Created by Nuno Gonçalves on 11/11/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

import UIKit

class CreditCardForm : UIControl {
    
    fileprivate let interButtonsSpacing: CGFloat = 10
    fileprivate let scrollViewContentPadding: CGFloat = 10
    
    fileprivate let scrollView = UIScrollView()
    
    fileprivate let numberInput = InputView(ofType: .number)
    fileprivate let dateInput = InputView(ofType: .expiryDate)
    fileprivate let securityCodeInput = InputView(ofType: .securityCode)
    fileprivate let nameInput = InputView(ofType: .name)
    
    override var backgroundColor: UIColor? {
        didSet {
            scrollView.backgroundColor = backgroundColor
        }
    }
    
    fileprivate var formItems: [InputView] = []
    fileprivate var selectedItem: InputView?
    
    var selectedIndex = -1 {
        didSet {
            selectItem(at: selectedIndex)
        }
    }
    
    @IBInspectable weak var delegate: CreditCardFormDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    fileprivate func initialize() {
        buildViews()
        selectItem(at: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    fileprivate func buildViews() {
        setUpScrollView()
        formItems = []
        setUpButtons()
    }
    
    fileprivate func setUpScrollView() {
        scrollView.subviews.forEach { $0.removeFromSuperview() }
        
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(scrollView)
    }
    
    fileprivate lazy var backButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .keyboardButton
        button.setTitle("← BACK", for: .normal)
        button.addTarget(self, action: #selector(previousTapped), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var nextButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .keyboardButton
        button.setTitle("NEXT →", for: .normal)
        button.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var keyboardToolbar: UIStackView = {
        let stackView = UIStackView(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        
        stackView.addArrangedSubviews([self.backButton, self.nextButton])
        
        return stackView
    }()
    
    @objc fileprivate func previousTapped() {
        let index = formItems.index(of: selectedItem!) ?? -1
        selectItem(at: index - 1)
    }
    
    @objc fileprivate func nextTapped() {
        let index = formItems.index(of: selectedItem!) ?? -1
        selectItem(at: index + 1)
    }
    
    fileprivate func setUpButtons() {
        formItems.append(numberInput)
        numberInput.textField.inputAccessoryView = keyboardToolbar
        numberInput.addTarget(self, action: #selector(becameFirstResponder(sender:)), for: .becameFirstResponder)
        numberInput.addTarget(self, action: #selector(tellTheDelegateTextChanged), for: .valueChanged)

        scrollView.addSubview(numberInput)
        formItems.append(dateInput)
        
        let datePicker = DatePicker(frame: CGRect(x: 0, y: 0, width: frame.width, height: 200))
        datePicker.addTarget(self, action: #selector(datePicked(sender:)), for: .valueChanged)
        datePicker.minimumDate = Date()
        
        dateInput.addTarget(self, action: #selector(tellTheDelegateTextChanged), for: .valueChanged)
        dateInput.addTarget(self, action: #selector(becameFirstResponder(sender:)), for: .becameFirstResponder)
        dateInput.textField.inputView = datePicker
        dateInput.textField.inputAccessoryView = keyboardToolbar
        
        scrollView.addSubview(dateInput)
        formItems.append(securityCodeInput)

        securityCodeInput.textField.inputAccessoryView = keyboardToolbar
        securityCodeInput.addTarget(self, action: #selector(becameFirstResponder(sender:)), for: .becameFirstResponder)
        securityCodeInput.addTarget(self, action: #selector(tellTheDelegateTextChanged), for: .valueChanged)
        scrollView.addSubview(securityCodeInput)
        
        nameInput.textField.inputAccessoryView = keyboardToolbar
        nameInput.addTarget(self, action: #selector(becameFirstResponder(sender:)), for: .becameFirstResponder)
        nameInput.addTarget(self, action: #selector(tellTheDelegateTextChanged), for: .valueChanged)
        
        scrollView.addSubview(nameInput)
        formItems.append(nameInput)
    }
    
    private let dateFormatter = DateFormatter(format: "MM/YY")
    @objc private func datePicked(sender: UIDatePicker) {
        let dateStr = dateFormatter.string(from: sender.date)
        dateInput.textField.text = dateStr
        delegate?.updated(cardExpiryDate: dateStr)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutViews()
    }
    
    fileprivate func layoutViews() {
        layoutScrollView()
        layoutButtons()
        centerContentIfPossible()
    }
    
    fileprivate var scrollViewAddedConstraints: [NSLayoutConstraint] = []
    
    fileprivate func layoutScrollView() {
        scrollViewAddedConstraints.forEach { $0.isActive = false }
        scrollViewAddedConstraints = []
        
        let _topAnchor = topAnchor.constraint(equalTo: scrollView.topAnchor)
        _topAnchor.isActive = true
        scrollViewAddedConstraints.append(_topAnchor)
        let _bottomAnchor = bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        _bottomAnchor.isActive = true
        scrollViewAddedConstraints.append(_bottomAnchor)
        
        let contentSize = scrollViewContentSize()
        scrollView.contentSize = contentSize
        
        if contentSize.width <= frame.width {
            let _centerXAnchor = centerXAnchor.constraint(equalTo: scrollView.centerXAnchor)
            _centerXAnchor.isActive = true
            scrollViewAddedConstraints.append(_centerXAnchor)
            
            let widthAnchor = scrollView.widthAnchor.constraint(equalToConstant: contentSize.width)
            widthAnchor.isActive = true
            scrollViewAddedConstraints.append(widthAnchor)
        } else {
            let _rightAnchor = rightAnchor.constraint(equalTo: scrollView.rightAnchor)
            _rightAnchor.isActive = true
            scrollViewAddedConstraints.append(_rightAnchor)
            let _leftAnchor = leftAnchor.constraint(equalTo: scrollView.leftAnchor)
            _leftAnchor.isActive = true
            scrollViewAddedConstraints.append(_leftAnchor)
        }
        
        scrollView.layoutIfNeeded()
    }
    
    fileprivate func layoutButtons() {
        var currentOffset: CGFloat = scrollViewContentPadding

        let scrollViewHeight = scrollView.frame.height
        
        formItems.enumerated().forEach { index, item in
            let width: CGFloat = CGFloat(item.type.textFieldRequiredWidth)
            let height: CGFloat = scrollViewHeight - 10
            let yOrigin = scrollViewHeight / 2 - height / 2
            
            item.frame = CGRect(x: currentOffset,
                                y: yOrigin,
                                width: width,
                                height: height)

            currentOffset += item.frame.width + interButtonsSpacing
        }
    }
    
    fileprivate func scrollViewContentSize() -> CGSize {
        guard formItems.count > 0 else { return CGSize(width: 0, height: 0) }
        
        let buttonsWidth = formItems.reduce(0) { widthSoFar, formItem in
            widthSoFar + formItem.frame.width
        }
        
        let intervalsWidth = CGFloat(interButtonsSpacing) * CGFloat(formItems.count - 1)
        let scrollViewPadding = scrollViewContentPadding * 2
        
        let contentWidth = scrollViewPadding + intervalsWidth + buttonsWidth
        
        return CGSize(width: contentWidth,
                      height: scrollView.bounds.height)
    }
    
    fileprivate func selectItem(at index: Int) {
        guard index <= formItems.count - 1 else { return }
        
        selectedItem?.isActive = false
        selectedItem = formItems[index]
        selectedItem?.isActive = true
        selectedItem?.textField.becomeFirstResponder()
        
        UIView.animate(withDuration: 0.3) {
            self.nextButton.isHidden = index >= self.formItems.count - 1
            self.backButton.isHidden = index < 1
        }
        tellTheDelegateTypeChanged()
        centerContentIfPossible()
    }
    
    @objc fileprivate func becameFirstResponder(sender: FormItemView) {
        selectedIndex = formItems.index(of: sender) ?? 0
    }
    
    fileprivate  func centerContentIfPossible() {
        guard let selectedItem = selectedItem else { return }
        
        let scrollViewWidth = scrollView.frame.width
        
        let newFrame = CGRect(x: selectedItem.center.x - scrollViewWidth / 2,
                              y: selectedItem.frame.origin.y,
                              width: scrollViewWidth,
                              height: scrollView.frame.height)
        
        scrollView.scrollRectToVisible(newFrame, animated: true)
    }
    
    @objc fileprivate func tellTheDelegateTypeChanged() {
        guard let type = selectedItem?.type else { return }
        delegate?.selected(type)
    }
    
    @objc fileprivate func tellTheDelegateTextChanged() {
        guard let selectedItem = selectedItem else { return }
        let value = selectedItem.textField.text ?? ""
        switch selectedItem.type {
        case .number: delegate?.updated(cardNumber: value)
        case .expiryDate: delegate?.updated(cardExpiryDate: value)
        case .securityCode: delegate?.updated(cardSecurityCode: value)
        case .name: delegate?.updated(cardName: value)
        }
    }
    
    
}

