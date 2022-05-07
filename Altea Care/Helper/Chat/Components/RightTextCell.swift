//
//  RightTextCell.swift
//  Altea Care
//
//  Created by Hedy on 13/03/21.
//

import UIKit

class RightTextCell: UITableViewCell {
    @IBOutlet weak var bubbleChatView: ACView!
    @IBOutlet weak var messageL: ACLabel!
    
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
