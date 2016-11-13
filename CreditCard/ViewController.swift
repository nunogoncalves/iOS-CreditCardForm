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
    
    @IBOutlet fileprivate weak var cardTypeLabel: UILabel!
    @IBOutlet fileprivate weak var cardTypeImageView: UIImageView!
    
    @IBOutlet fileprivate weak var cardOverlayView: UIView!
    @IBOutlet fileprivate weak var front: UIImageView!
    @IBOutlet fileprivate weak var back: UIImageView!
    
    @IBOutlet fileprivate weak var creaditCardForm: CreditCardForm!
    
    @IBOutlet fileprivate weak var cardNumberTextView: UITextView! {
        didSet {
            cardNumberTextView.textContainerInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
            let exclusionHeight = cardNumberTextView.frame.height
            cardNumberTextView.textContainer.exclusionPaths = [55, 110, 165].map {
                UIBezierPath(rect: CGRect(x: $0, y: 0, width: 1, height: exclusionHeight))
            }
        }
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
            cvvTextView.textContainerInset = UIEdgeInsets(top: 6, left: 0, bottom: 0, right: 0)
        }
    }
    
    fileprivate var selectedFormItemType = FormItemType.number
    fileprivate var selectedCardType: CreditCardType?
    
    fileprivate var isFrontVisible = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        creaditCardForm.delegate = self
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
        cardNumberTextView.text = cardNumber.isEmpty ? "XXXXXXXXXXXXXXXX" : cardNumber
        let type = CreditCardValidator.type(for: cardNumber)
        cardTypeLabel.text = type?.rawValue
        cardTypeImageView.image = type?.image
        
        if type == selectedCardType {
            return
        }
        
        if type != nil {
            animateCardChange(addingCard: true)
        } else {
            animateCardChange(addingCard: false)
        }
       
        selectedCardType = type
    }
    
    func updated(cardSecurityCode: String) {
        cvvTextView.text = cardSecurityCode
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
