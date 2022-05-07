//
//  AlteaView.swift
//  Altea Care
//
//  Created by Hedy on 08/03/21.
//

import UIKit

@IBDesignable
public class AlteaView: UIView {
    @IBInspectable
    public var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable
    public var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable
    public var customCorner: Bool = false
    
    @IBInspectable
    public var cornerRadius: CGFloat = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    public var shadowColor: UIColor = UIColor.clear {
        didSet {
            layer.shadowColor = shadowColor.cgColor
        }
    }
    
    @IBInspectable
    public var shadowRadius: CGFloat = 0 {
        didSet {
            layer.shadowRadius = shadowRadius
        }
    }
    
    @IBInspectable
    public var shadowOpacity: CGFloat = 0 {
        didSet {
            layer.shadowOpacity = Float(shadowOpacity)
        }
    }
    
    @IBInspectable
    public var shadowOffsetY: CGFloat = 0 {
        didSet {
            layer.shadowOffset.height = shadowOffsetY
        }
    }
    
    @IBInspectable
    public var topLeft: Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable
    public var topRight: Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable
    public var bottomLeft: Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable
    public var bottomRight: Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        if customCorner == false {
            layer.cornerRadius = cornerRadius
        } else {
            var corners: UIRectCorner = []
            if topLeft {
                corners.formUnion(.topLeft)
            }
            if topRight {
                corners.formUnion(.topRight)
            }
            if bottomLeft {
                corners.formUnion(.bottomLeft)
            }
            if bottomRight {
                corners.formUnion(.bottomRight)
            }
            roundCorners(corners: corners, radius: cornerRadius)
        }
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        if #available(iOS 11.0, *) {
            clipsToBounds = true
            layer.cornerRadius = radius
            layer.maskedCorners = CACornerMask(rawValue: corners.rawValue)
        } else {
            let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            layer.mask = mask
        }
    }
}
