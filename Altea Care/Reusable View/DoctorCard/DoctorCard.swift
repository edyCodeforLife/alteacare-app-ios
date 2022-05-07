//
//  DoctorCard.swift
//  Altea Care
//
//  Created by Hedy on 8/3/21.
//

import UIKit

class DoctorCard: UIView {
    
    var contentView:UIView?
    @IBInspectable var nibName:String? = "DoctorCard"
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var hospitalIcon: UIImageView!
    @IBOutlet weak var hospitalName: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var profession: UILabel!
    
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
        self.image.layer.cornerRadius = 6
        self.hospitalName.textColor = .systemGray
        self.name.textColor = .alteaDark1
        self.profession.textColor = .alteaDark1
        
        self.hospitalName.font = UIFont.font(size: 11, fontType: .normal)
        self.name.font = UIFont.font(size: 14, fontType: .bold)
        self.profession.font = UIFont.font(size: 12, fontType: .normal)
    }
    
    func setupCard(image: UIImage?, hospitalIcon: UIImage?, hospital: String?, name: String?, profession: String?) {
        self.image.image = image
        self.hospitalIcon.image = hospitalIcon
        self.hospitalName.text = hospital
        self.name.text = name
        self.profession.text = profession
    }
    
}
