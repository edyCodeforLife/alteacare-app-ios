//
//  OptionsCell.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 05/04/21.
//

import UIKit

class OptionsCell: UITableViewCell {

    @IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var labelOptions: UILabel!
    @IBOutlet weak var chevronIcon: UIImageView!
    @IBOutlet weak var line: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func configure(with model : ProfileOption){
        self.imageIcon.image = model.imageOption
        self.labelOptions.text = model.tittle
        self.chevronIcon.isHidden = model.isHiddenChevron
    }
    
}
