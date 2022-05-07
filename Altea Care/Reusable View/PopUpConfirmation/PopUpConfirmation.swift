//
//  PopUpConfirmation.swift
//  Altea Care
//
//  Created by Hedy on 22/3/21.
//

import UIKit

class PopUpConfirmation: UIView {
    
    @IBOutlet weak var confirmLabel: ACLabel!
    @IBOutlet weak var cancelButton: ACButton!
    @IBOutlet weak var confirmButton: ACButton!
    @IBOutlet weak var popupContainer: UIView!
    
    var onCancelButtonTapped: (() -> Void)?
    var onConfirmButtonTapped: (() -> Void)?
    var contentView:UIView?
    @IBInspectable var nibName:String? = "PopUpConfirmation"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
        setupInit()
    }
        
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
        setupInit()
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
        self.setupUI()
    }
    
    private func setupUI() {
        self.confirmLabel.font = .font(size: 14, fontType: .normal)
        self.confirmLabel.textColor = .alteaDark2
        self.popupContainer.layer.cornerRadius = 8
        self.popupContainer.layer.shadowRadius = 8
        self.popupContainer.layer.shadowOffset = CGSize(width: 2, height: 3)
        self.popupContainer.layer.shadowOpacity = 10
        self.popupContainer.layer.shadowColor = UIColor.alteaLight1.cgColor
        self.popupContainer.layer.shouldRasterize = true

    }
    
    func setPopUp(text: String?, cancelBtnText: String?, cancelBtnType: ACButton.Style, confirmBtnText: String?, confirmBtnType: ACButton.Style) {
        self.confirmLabel.text = text
        self.cancelButton.set(type: cancelBtnType, title: cancelBtnText ?? "")
        self.confirmButton.set(type: confirmBtnType, title: confirmBtnText ?? "")
        
    }
    
}
