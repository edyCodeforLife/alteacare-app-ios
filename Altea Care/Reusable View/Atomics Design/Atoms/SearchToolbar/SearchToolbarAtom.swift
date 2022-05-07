//
//  SearchToolbarAtom.swift
//  Altea Care
//
//  Created by Nur Irfan Pangestu on 30/12/21.
//

import UIKit

class SearchToolbarAtom: UIView {
    
    var contentView : UIView?
    @IBInspectable var nibName : String? = "SearchToolbarAtom"

    @IBOutlet weak var containerSearch: UIView!
    @IBOutlet weak var inputSearch: UITextField!
    
    override init(frame: CGRect){
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
        setupUI()
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
    
    private func setupUI() {
        self.containerSearch.layer.cornerRadius = 20
    }
        
}
