//
//  ListDoctorTableViewCell.swift
//  Altea Care
//
//  Created by Rahmad Hidayat on 10/05/21.
//

import UIKit

class ListDoctorTableViewCell: UITableViewCell {
    
    @IBOutlet weak var personIV: UIImageView!
    @IBOutlet weak var experienceLabel: UILabel!
    @IBOutlet weak var hospitalNameLabel: UILabel!
    @IBOutlet weak var doctorLabel: UILabel!
    @IBOutlet weak var langLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var specializeLabel: UILabel!
    @IBOutlet weak var hospitalIV: UIImageView!
    @IBOutlet weak var freeIV: UIImageView!
    @IBOutlet weak var onlineView: CardView!
    @IBOutlet weak var flatPriceLabel: UILabel!
    @IBOutlet weak var praktikLabel: UILabel!
    
    var actionGoToDetailDoctor: (() -> Void)? = nil
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        // Initialization code
    }
    
    
    @IBAction func goToDetailDoctor(_ sender: Any) {
        self.actionGoToDetailDoctor?()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
