//
//  ViewController.swift
//  CreditCard
//
//  Created by Nuno Gonçalves on 10/11/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet fileprivate weak var cardContainer: UIView!
    
    @IBOutlet fileprivate weak var frontContainer: UIView!
    @IBOutlet fileprivate weak var backContainer: UIView!
    
    @IBOutlet fileprivate weak var front: UIImageView!
    @IBOutlet fileprivate weak var back: UIImageView!
    
    @IBOutlet fileprivate weak var creaditCardForm: CreditCardForm!
    
    fileprivate var selectedType = FormItemType.number
    
    @IBOutlet fileprivate weak var cardNumberTextView: UITextView! {
        didSet {
            cardNumberTextView.textContainerInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
            let exclusionHeight = cardNumberTextView.frame.height
            cardNumberTextView.textContainer.exclusionPaths = [50, 100, 150].map {
                UIBezierPath(rect: CGRect(x: $0, y: 0, width: 1, height: exclusionHeight))
            }
        }
    }
    
    fileprivate var activeTextField: UITextField?
    
    @IBAction fileprivate func startedEditing(sender: UITextField) {
        activeTextField = sender
    }
    
    @IBOutlet fileprivate weak var cardExpiryDateTextView: UITextView! {
        didSet {
            cardExpiryDateTextView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    @IBOutlet fileprivate weak var cardNameTextView: UITextView! {
        didSet {
            cardNameTextView.textContainerInset = UIEdgeInsets(top: 2, left: 5, bottom: 0, right: 0)
        }
    }
    
    @IBOutlet fileprivate weak var cvvTextView: UITextView! {
        didSet {
            cvvTextView.textContainerInset = UIEdgeInsets(top: 2, left: 0, bottom: 0, right: 0)
        }
    }
    
    var isFrontVisible = true
    
    @IBAction fileprivate func cardValueChanged(_ sender: UITextField) {
        cardNumberTextView.text = sender.text
    }
    
    @IBAction fileprivate func cardNameChanged(_ sender: UITextField) {
        cardNameTextView.text = sender.text
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        creaditCardForm.delegate = self
    }
    
    fileprivate func flip(using direction: UIViewAnimationOptions) {
        UIView.transition(with: cardContainer,
                          duration: 0.4,
                          options: direction,
                          animations: {
                            if self.isFrontVisible {
                                self.frontContainer.isHidden = true
                                self.backContainer.isHidden = false
                            } else {
                                self.frontContainer.isHidden = false
                                self.backContainer.isHidden = true
                            }
        },
                          completion: { completed in
                            if completed {
                                self.isFrontVisible = !self.isFrontVisible
                            }
        })
    }
}

extension ViewController : CreditCardFormDelegate {
    func updated(cardName: String) {
        cardNameTextView.text = cardName
    }
    
    func updated(cardExpiryDate: String) {
        cardExpiryDateTextView.text = cardExpiryDate
    }
    
    func updated(cardNumber: String) {
        cardNumberTextView.text = cardNumber
    }
    
    func updated(cardSecurityCode: String) {
        cvvTextView.text = cardSecurityCode
    }
    
    func selected(_ type: FormItemType) {
        guard selectedType != type else { return }
        
        if type == .securityCode {
            flip(using: .transitionFlipFromRight)
        } else {
            if selectedType == .securityCode {
                flip(using: .transitionFlipFromLeft)
            }
        }
        selectedType = type
    }
}

