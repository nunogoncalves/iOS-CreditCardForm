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
    @IBOutlet fileprivate weak var cardNumberTextView: UITextView!
    @IBOutlet fileprivate weak var cardExpiryDateTextView: UITextView!
    @IBOutlet fileprivate weak var cardNameTextView: UITextView!
    @IBOutlet fileprivate weak var securityCodeTextView: UITextView!
    
    @IBOutlet fileprivate weak var backContainer: UIView!
    
    @IBOutlet fileprivate weak var cardTypeLabel: UILabel!
    @IBOutlet fileprivate weak var cardTypeImageView: UIImageView!
    
    @IBOutlet fileprivate weak var cardOverlayView: UIImageView!
    @IBOutlet fileprivate weak var front: UIImageView!
    @IBOutlet fileprivate weak var back: UIImageView!
    
    @IBOutlet fileprivate weak var creaditCardForm: CreditCardForm!
    
    fileprivate var selectedFormItemType = FormItemType.number
    fileprivate var selectedCardType: CreditCardType?
    
    fileprivate var isFrontVisible = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        applyTextFieldTextContainerInsets()

        creaditCardForm.delegate = self
    }
    
    private func applyTextFieldTextContainerInsets() {
        cardNumberTextView.textContainerInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        cardExpiryDateTextView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        cardNameTextView.textContainerInset = UIEdgeInsets(top: 2, left: 5, bottom: 0, right: 0)
        securityCodeTextView.textContainerInset = UIEdgeInsets(top: 6, left: 0, bottom: 0, right: 0)
    }
    
    private let cardMaskLayer = CAShapeLayer()
    private let cardTypeChangeAnimationDuration: TimeInterval = 0.2
    
    func animateCardChange(addingCard: Bool) {
        
        if addingCard {
            cardOverlayView.isHidden = false
        }
        
        cardMaskLayer.path = bigCirclePath
        cardMaskLayer.fillColor = UIColor.black.cgColor
        cardOverlayView.layer.mask = cardMaskLayer
        
        CATransaction.begin()
        
        let pathAnimation = CABasicAnimation(keyPath: "path")
        if addingCard {
            pathAnimation.fromValue = smallCirclePath
            pathAnimation.toValue = bigCirclePath
        } else {
            pathAnimation.fromValue = bigCirclePath
            pathAnimation.toValue = smallCirclePath
        }
        
        pathAnimation.duration = cardTypeChangeAnimationDuration
        
        CATransaction.setCompletionBlock {
            if !addingCard {
                self.cardOverlayView.isHidden = true
            }
            self.cardOverlayView.layer.mask = nil
            self.cardMaskLayer.removeAllAnimations()
        }

        cardMaskLayer.add(pathAnimation, forKey: "animation")
        CATransaction.commit()
    }
    
    private lazy var smallCirclePath: CGPath = {
        let center = CGPoint(x: 0, y: 0)
        let radius: CGFloat = 1 // if its 0, the animation won't be nice.
        return self.circle(with: center, and: radius).cgPath
    }()
    
    private lazy var bigCirclePath: CGPath = {
        let center = CGPoint(x: self.frontContainer.frame.width / 2,
                             y: self.frontContainer.frame.height / 2)
        return self.circle(with: center, and: self.bigCircleRadius).cgPath
    }()
    
    private lazy var bigCircleRadius: CGFloat = {
        let halfWidth = self.frontContainer.frame.width / 2
        let halfHeight = self.frontContainer.frame.height / 2
        
        let center = CGPoint(x: halfWidth, y: halfHeight)
        
        return √(halfWidth.² + halfHeight.²)
    }()
    
    private func circle(with center: CGPoint, and radius: CGFloat) -> UIBezierPath {
        return UIBezierPath(arcCenter: center,
                            radius: radius,
                            startAngle: 0,
                            endAngle: 2 * .pi,
                            clockwise: true)
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
        let formattedNumber = addSpacesIfNecessary(to: cardNumber)
        
        cardNumberTextView.text = formattedNumber.isEmpty ? "XXXX XXXX XXXX XXXX" : formattedNumber
        
        let type = CreditCardValidator.type(for: cardNumber)
        
        if type == selectedCardType {
            return
        }
        
        cardTypeLabel.text = type?.rawValue
        cardTypeImageView.image = type?.image
        if let backgroundImage = type?.backgroundImage {
            cardOverlayView.image = backgroundImage
        }
        
        animateCardChange(addingCard: type != nil)
       
        selectedCardType = type
    }
    
    private func addSpacesIfNecessary(to cardNumber: String) -> String {
        var formatterNumber = ""
        for (index, character) in cardNumber.characters.enumerated() {
            if index % 4 == 0 {
                formatterNumber.append(" \(character)")
            } else {
                formatterNumber.append(character)
            }
        }
        return formatterNumber
    }
    
    func updated(cardSecurityCode: String) {
        securityCodeTextView.text = cardSecurityCode
    }
    
    func selected(_ type: FormItemType) {
        guard selectedFormItemType != type else { return }
        
        if type == .securityCode {
            flip(using: .transitionFlipFromRight)
        } else {
            if selectedFormItemType == .securityCode {
                flip(using: .transitionFlipFromLeft)
            }
        }
        selectedFormItemType = type
    }
}

fileprivate extension CGFloat {
    
    var ²: CGFloat {
        return self * self
    }
}

prefix operator √
fileprivate prefix func √(a: CGFloat) -> CGFloat {
    return sqrt(a)
}
