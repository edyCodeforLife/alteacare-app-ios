//
//  ListHospitalTableViewCell.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 15/10/21.
//

import UIKit

class ListHospitalTableViewCell: UITableViewCell {

    @IBOutlet weak var nameHospitalLabel: UILabel!
    @IBOutlet weak var checkUncheckImageView: UIImageView!
    
    public static let identifier = "FilterCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
