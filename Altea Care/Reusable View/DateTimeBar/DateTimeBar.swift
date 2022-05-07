//
//  DateTimeBar.swift
//  Altea Care
//
//  Created by Hedy on 8/3/21.
//

import UIKit

class DateTimeBar: UIView {
    
    var contentView:UIView?
    @IBInspectable var nibName:String? = "DateTimeBar"
    
    @IBOutlet weak var leftIcon: UIImageView!
    @IBOutlet weak var rightIcon: UIImageView!
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
        setupInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
        setupInit()
        setupUI()
    }
    
    func xibSetup() {
        guard let view = loadViewFromNib() else { return }
        view.frame = bounds
        view.autoresizingMask =
            [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        contentView = view
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
        
    }
    
    private func setupUI() {
        
    }
    
    func setupBar(leftLabel: String?, rightLabel: String?, color: TextColor) {
        self.layer.masksToBounds = true
        self.leftLabel.text = leftLabel
        self.rightLabel.text = rightLabel
        self.leftLabel.font = UIFont.font(size: 12, fontType: .bold)
        self.rightLabel.font = UIFont.font(size: 12, fontType: .bold)
        if color == .blue {
            self.leftIcon.tintColor = .alteaBlueMain
            self.rightIcon.tintColor = .alteaBlueMain
            self.leftLabel.textColor = .alteaBlueMain
            self.rightLabel.textColor = .alteaBlueMain
        } else {
            self.leftIcon.tintColor = .systemGray
            self.rightIcon.tintColor = .systemGray
            self.leftLabel.textColor = .systemGray
            self.rightLabel.textColor = .systemGray
        }
    }

}

enum TextColor {
    case blue
    case gray
    
}
