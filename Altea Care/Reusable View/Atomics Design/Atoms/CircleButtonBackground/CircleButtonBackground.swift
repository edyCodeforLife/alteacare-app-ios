//
//  CircleButtonBackground.swift
//  Altea Care
//
//  Created by Nur Irfan Pangestu on 18/12/21.
//

import UIKit

enum FontStyle {
    case weight700
    case weight600
    case weight500
    case weight400
}


class CircleButtonBackground: UIView {
    
    var contentView : UIView?
    @IBInspectable var nibName : String? = "CircleButtonBackground"
        
    
    enum Style {
        case clear(title: String, color: String)
        case fill(title: String, color: String, background: String, radius: CGFloat)
        case stroke(title: String, color: String, background: String, borderColor: String, radius: CGFloat)
        
        var title: String {
            switch self {
            case .clear(let title, _):
                return title
            case .fill(let title, _, _, _):
                return title
            case .stroke(let title, _, _, _, _):
                return title
            }
        }
        
        var color: String {
            switch self {
            case .clear(_, let color):
                return color
            case .fill(_, let color, _, _):
                return color
            case .stroke(_, let color, _, _, _):
                return color
            }
        }

        var background: String {
            switch self {
            case .clear(_, _):
                return ""
            case .fill(_, _, let background, _):
                return background
            case .stroke(_, _, let background, _, _):
                return background
            }
        }
        
        var borderColor: String {
            switch self {
            case .clear(_, _):
                return ""
            case .fill(_, _, _, _):
                return ""
            case .stroke(_, _, _, let borderColor, _):
                return borderColor
            }
        }
        
        var cornerRadius: CGFloat {
            switch self {
            case .clear(_, _):
                return 0
            case .fill(_, _, _, let radius):
                return radius
            case .stroke(_, _, _, _, let radius):
                return radius
            }
        }
    }

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleButton: UILabel!
    @IBOutlet weak var leadingMarginButton: NSLayoutConstraint!
    @IBOutlet weak var trailingMarginButton: NSLayoutConstraint!
    override init(frame: CGRect){
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    private func xibSetup(){
        guard let view = loadViewFromNib() else { return }
        view.frame = bounds
        view.autoresizingMask =
            [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        contentView = view
    }
    
    func loadViewFromNib() -> UIView?{
        guard let nibName = nibName else { return nil }
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(
            withOwner: self,
            options: nil).first as? UIView
    }
        
    func setupCornerRadius(radius: CGFloat) {
        self.containerView.layer.cornerRadius = radius
    }
        
    func setupFont(size: CGFloat, fontType: FontStyle) {
        switch fontType {
        case .weight700:
            self.titleButton.font = UIFont.font(size: size, fontType: .bold)
        case .weight600:
            self.titleButton.font = UIFont.font(size: size, fontType: .medium)
        case .weight500:
            self.titleButton.font = UIFont.font(size: size, fontType: .normal)
        case .weight400:
            self.titleButton.font = UIFont.font(size: size, fontType: .thin)
        }
        
    }
    
    // MARK: - SETUP TITLE
    func setupButton(style: CircleButtonBackground.Style, sizeFont: CGFloat, fontType: FontStyle) {
        self.titleButton.text = style.title

        switch style {
        case .clear(_, _):
            self.titleButton.textColor = UIColor(hexString: style.color)
            self.containerView.backgroundColor = UIColor.clear
        case .fill(_, _, _, _):
            self.titleButton.textColor = UIColor(hexString: style.color)
            self.containerView.backgroundColor = UIColor(hexString: style.background)
            self.containerView.layer.cornerRadius = style.cornerRadius
            self.containerView.clipsToBounds = true
            
        case .stroke(_, _, _, _, _):
            self.titleButton.textColor = UIColor(hexString: style.color)
            self.containerView.backgroundColor = UIColor(hexString: style.background)
            self.containerView.layer.borderWidth = 1
            self.containerView.layer.borderColor = UIColor(hexString: style.borderColor).cgColor
            self.containerView.layer.cornerRadius = style.cornerRadius
            self.containerView.clipsToBounds = true
        }
        switch fontType {
        case .weight700:
            self.titleButton.font = UIFont.font(size: sizeFont, fontType: .bold)
        case .weight600:
            self.titleButton.font = UIFont.font(size: sizeFont, fontType: .medium)
        case .weight500:
            self.titleButton.font = UIFont.font(size: sizeFont, fontType: .normal)
        case .weight400:
            self.titleButton.font = UIFont.font(size: sizeFont, fontType: .thin)
        }
    }
    
}
