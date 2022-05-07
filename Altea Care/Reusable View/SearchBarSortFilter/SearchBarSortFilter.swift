//
//  SearchBarSortFilter.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 09/04/21.
//

import UIKit

class SearchBarSortFilter: UIView {
    
    var contentView : UIView?
    @IBInspectable var nibName : String? = "SearchBarSortFilter"
    
    var onFilterButtonTapped : (() -> Void)?
    var onSortDoctorButtonTapped: (() -> Void)?
    
    @IBOutlet weak var searchText: UITextField!
    @IBOutlet weak var filterButton: UIImageView!
    @IBOutlet weak var sortButton: UIImageView!
    
    override init(frame: CGRect){
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
    
    func xibSetup(){
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
    
    private func setupInit() {
        
    }
    
    private func setupUI() {
        self.searchText.layer.cornerRadius = self.searchText.layer.bounds.height/2
        self.searchText.backgroundColor = .alteaLight3
        self.searchText.clipsToBounds = true
        
        self.searchText.leftViewMode = .always
        let imageView = UIImageView(frame: CGRect(x: 10, y: 5, width: 30, height: 30))
        let image: UIImage? = #imageLiteral(resourceName: "search")
        imageView.image = image
        let padding = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        searchText.leftView = padding
        searchText.addSubview(imageView)
        
        self.sortButton.addTapGestureRecognizer {
            self.onSortDoctorButtonTapped?()
        }
        
        self.filterButton.addTapGestureRecognizer{
            self.onFilterButtonTapped?()
        }
    }
}
