//
//  FormTextView.swift
//  Altea Care
//
//  Created by Admin on 10/3/21.
//

import UIKit

class FormTextView: UIView {

    var contentView:UIView?
    @IBInspectable var nibName:String? = "FormTextView"
    
    @IBOutlet weak var title: ACLabel!
    @IBOutlet weak var value: UITextView!
    
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
        self.title.textColor = .alteaDark3
        self.value.textColor = .alteaDark3
        self.value.font = UIFont(name: "Inter-Black", size: 13)
    }
    
    func setupTextValue(title: String?, value: String?) {
        self.title.text = title
        self.value.text = value
    }
}
