//
//  PaymentMethodItemCell.swift
//  Altea Care
//
//  Created by Tiara on 10/05/21.
//

import UIKit

class PaymentMethodItemCell: UITableViewCell {

    @IBOutlet weak var methodIV: UIImageView!
    @IBOutlet weak var nameL: UILabel!
    @IBOutlet weak var descL: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
