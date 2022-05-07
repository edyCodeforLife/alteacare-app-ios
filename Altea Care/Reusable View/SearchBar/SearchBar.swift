//
//  SearchBar.swift
//  Altea Care
//
//  Created by Admin on 16/3/21.
//

import UIKit

class SearchBar: UIView {
    
    var contentView:UIView?
    @IBInspectable var nibName:String? = "SearchBar"
    
    var onSortButtonTapped: (() -> Void)?
    var onFilterButtonTapped: (() -> Void)?
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sortButton: UIStackView!
    @IBOutlet weak var filterButton: UIStackView!
    @IBOutlet weak var sortLabel: ACLabel!
    
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
        self.textField.layer.cornerRadius = self.textField.layer.bounds.height/2
        self.textField.backgroundColor = .alteaLight3
        self.textField.clipsToBounds = true
        
        self.textField.leftViewMode = .always
        let imageView = UIImageView(frame: CGRect(x: 10, y: 5, width: 30, height: 30))
        let image: UIImage? = #imageLiteral(resourceName: "search")
        imageView.image = image
        let padding = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        textField.leftView = padding
        textField.addSubview(imageView)
        
        self.sortButton.addTapGestureRecognizer {
            self.onSortButtonTapped?()
        }
        
        self.filterButton.addTapGestureRecognizer {
            self.onFilterButtonTapped?()
        }
    }
    
    
}
