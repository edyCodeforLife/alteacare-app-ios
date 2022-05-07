//
//  ACButton.swift
//  Altea Care
//
//  Created by Hedy on 09/03/21.
//

import UIKit

class ACButton: UIView {
    
    var onTapped: (() -> Void)?

    @IBOutlet weak private var button: UIButton!
    @IBOutlet weak var rightIcon: UIImageView!
    @IBOutlet weak var leftIcon: UIImageView!
    
    @IBAction func onTapped(_ sender: Any) {
        self.onTapped?()
    }
    
    enum IconPosition {
        case left
        case right
    }
    
    enum TitlePosition {
        case center
        case left
        case right
    }
    
    enum Style {
        case filled(custom: UIColor?)
        case bordered(custom: UIColor?)
        case link(custom: UIColor?)
        case disabled
        case redButtonText
        case blueButtonText
        case greenAlteaButtonText
        
        var backgroundColor: UIColor {
            switch self {
            case .filled(let custom):
                guard let custom = custom else { return .primary }
                return custom
            case .bordered:
                return .white
            case .disabled:
                return .darker
            case .link( _):
                return .clear
            case .redButtonText:
                return .white
            case .blueButtonText:
                return .white
            case .greenAlteaButtonText:
                return .clear
            }
        }
        
        var titleColor: UIColor {
            switch self {
            case .filled:
                return .white
            case .bordered(let custom):
                guard let custom = custom else { return .primary }
                return custom
            case .disabled:
                return .white
            case .link(let custom):
                guard let custom = custom else { return .white }
                return custom
            case .redButtonText:
                return .red
            case .blueButtonText:
                return .info
            case .greenAlteaButtonText:
                return .alteaMainColor
            }
        }
        
        var borderColor: UIColor {
            switch self {
            case .filled(let custom):
                guard let custom = custom else { return .primary }
                return custom
            case .bordered(let custom):
                guard let custom = custom else { return .primary }
                return custom
            case .disabled:
                return .darker
            case .link( _):
                return .clear
            case .redButtonText:
                return .clear
            case .blueButtonText:
                return .clear
            case .greenAlteaButtonText:
                return .clear
            }
        }
        
        var isEnable: Bool {
            switch self {
            case .disabled:
                return false
            default:
                return true
            }
        }
        
    }
    
    var contentView:UIView?
    @IBInspectable var nibName:String? = "ACButton"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
        setupInit()
        self.tappedImageBody()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
        setupInit()
        self.tappedImageBody()
    }
    
    func xibSetup() {
        guard let view = loadViewFromNib() else { return }
        view.frame = bounds
        view.autoresizingMask =
        [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        contentView = view
        self.tappedImageBody()
    }
    
    func loadViewFromNib() -> UIView? {
        guard let nibName = nibName else { return nil }
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(
            withOwner: self,
            options: nil).first as? UIView
    }
    
    private func setupInit() {
        self.setupDefaultTitle()
        self.setupContainer()
        self.setupButtonIcon()
    }
    
    private func tappedImageBody(){
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tappedImage(_:)))
        self.leftIcon.addGestureRecognizer(gesture)
    }
    
    @objc func tappedImage(_ gestureRecognizer: UITapGestureRecognizer){
        self.onTapped?()
    }
    
    private func setupDefaultTitle() {
        self.button.titleLabel?.font = .font()
    }
    
    private func setupContainer() {
        self.button.layer.cornerRadius = 5
        self.button.layer.borderWidth = 1
    }
    
    private func setupButtonIcon() {
        self.leftIcon.isHidden = true
        self.rightIcon.isHidden = true
    }
    
    func setTitle(title: String) {
        self.button.setTitle(title, for: .normal)
        self.button.titleLabel?.font = UIFont.font(fontType: .bold)
    }
    
    func set(type: Style, title: String, titlePosition: TitlePosition? = nil, font: UIFont = .font(fontType: .bold), icon: UIImage? = nil, iconPosition: IconPosition? = nil) {
        self.button.backgroundColor = type.backgroundColor
        self.button.layer.borderColor = type.borderColor.cgColor
        self.button.setTitle(title, for: .normal)
        self.button.setTitleColor(type.titleColor, for: .normal)
        self.button.titleLabel?.font = font
        self.button.isEnabled = type.isEnable
        
        if let position = titlePosition {
            switch position {
            case .center:
                button.contentHorizontalAlignment = .center
            case .left:
                button.contentHorizontalAlignment = .left
                button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            case .right:
                button.contentHorizontalAlignment = .right
                button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
            }
        }
        
        if let position = iconPosition {
            switch position {
            case .left:
                self.leftIcon.isHidden = false
                self.leftIcon.image = icon
            case .right:
                self.rightIcon.isHidden = false
                self.rightIcon.image = icon
            }
        }
        
        switch type {
        case .link( _):
            self.button.titleLabel?.attributedText = title.underLined
        default:
            self.button.setTitle(title, for: .normal)
        }
    }
    
}
