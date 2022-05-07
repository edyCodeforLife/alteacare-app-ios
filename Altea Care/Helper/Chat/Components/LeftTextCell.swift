//
//  LeftTextCell.swift
//  Altea Care
//
//  Created by Hedy on 14/03/21.
//

import UIKit

class LeftTextCell: UITableViewCell {
    @IBOutlet weak var messageL: ACLabel!
    @IBOutlet weak var bubbleChatView: ACView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
