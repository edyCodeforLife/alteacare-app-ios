//
//  TableRow.swift
//  Altea Care
//
//  Created by Hedy on 16/3/21.
//

import UIKit

class TableRow: UIView {
    
    var contentView:UIView?
    @IBInspectable var nibName:String? = "TableRow"

    @IBOutlet weak var title: ACLabel!
    @IBOutlet weak var value: ACLabel!
    @IBOutlet weak var imageView: UIImageView!
    
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
        self.title.textColor = .alteaBlueMain
        self.value.textColor = .alteaDark3
        self.imageView.isHidden = false
    }
    
    func setupTextValue(title: String?, value: String?, isHighlighted: Bool = false, image: UIImage? = nil) {
        self.title.text = title
        self.value.text = value
        
        if isHighlighted {
            self.title.font = .font(size: 15, fontType: .bold)
            self.value.font = .font(size: 15, fontType: .bold)
        } else {
            self.title.font = .font()
            self.value.font = .font()
        }
        
//        if let image = image {
//            self.imageView.image = image
//            self.imageView.isHidden = false
//            self.value.font = .font(size: 15, fontType: .bold)
//        } else {
//            self.imageView.isHidden = true
//        }
        
    }
}

