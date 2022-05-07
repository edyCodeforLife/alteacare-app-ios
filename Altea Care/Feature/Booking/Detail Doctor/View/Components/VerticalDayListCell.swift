//
//  SevenDayListCell.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 12/04/21.
//

import UIKit

class VerticalDayListCell: UICollectionViewCell {
    @IBOutlet weak var labelDateTime: UILabel!
    @IBOutlet weak var buttonSeeAll: UIButton!
    
    var onSeeAllTapped : (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func onSeeAllAction(_ sender: Any) {
        self.onSeeAllTapped?()
    }
}
