//
//  ReceiptPaymentTableViewCell.swift
//  Altea Care
//
//  Created by Rahmad Hidayat on 12/07/21.
//

import UIKit

class ReceiptPaymentTableViewCell: UITableViewCell {

    @IBOutlet weak var lbtitle: UILabel!
    @IBOutlet weak var ivBank: UIImageView!
    @IBOutlet weak var ivNameBank: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
