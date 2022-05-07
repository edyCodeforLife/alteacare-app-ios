//
//  MemberChooseCell.swift
//  Altea Care
//
//  Created by Tiara on 25/08/21.
//

import UIKit

class MemberChooseCell: UITableViewCell {
    @IBOutlet weak var profileIV: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var profileRoleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
