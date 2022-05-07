//
//  ChipsBarCell.swift
//  Altea Care
//
//  Created by Nur Irfan Pangestu on 18/12/21.
//

import UIKit

class ChipsBarCell: UICollectionViewCell {
    
    var onRemoveChipsbarTapped: ((TagList) -> Void)?
    
    @IBOutlet weak var containerViewChips: UIView!
    @IBOutlet weak var lblTitleChipsBar: UILabel!
    @IBOutlet weak var btnCloseChipsBar: UIButton!
    
    var model: TagList?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.containerViewChips.layer.cornerRadius = 16
        self.lblTitleChipsBar.font = .font(size: 9, fontType: .normal)
    }

    func setupTitleChipsbar(model: TagList) {
        self.model = model
        self.lblTitleChipsBar.text = model.name
    }
    
    @IBAction func btnRmove(_ sender: Any) {
        self.onRemoveChipsbarTapped?(model!)
    }
    
}
