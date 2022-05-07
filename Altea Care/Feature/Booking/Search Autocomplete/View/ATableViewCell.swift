//
//  ATableViewCell.swift
//  Altea Care
//
//  Created by Rahmad Hidayat on 09/07/21.
//

import UIKit

class ATableViewCell: UITableViewCell {

    @IBOutlet weak var lbText: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
