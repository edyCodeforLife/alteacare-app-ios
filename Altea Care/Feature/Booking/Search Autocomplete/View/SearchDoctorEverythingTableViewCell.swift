//
//  SearchDoctorEverythingTableViewCell.swift
//  Altea Care
//
//  Created by Rahmad Hidayat on 09/07/21.
//

import UIKit

class SearchDoctorEverythingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lbSpecialization: UILabel!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbExperience: UILabel!
    @IBOutlet weak var ivPotoProfil: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        ivPotoProfil.layer.cornerRadius = 4.0
        ivPotoProfil.clipsToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
