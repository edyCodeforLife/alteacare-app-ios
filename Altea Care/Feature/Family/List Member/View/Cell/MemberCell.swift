//
//  MemberCell.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 02/08/21.
//

import UIKit

protocol MemberCellDelegate: AnyObject{
    func option(id: String)
}

class MemberCell: UITableViewCell {
    
    @IBOutlet weak var imageUser: UIImageView!
    @IBOutlet weak var labelUserName: UILabel!
    @IBOutlet weak var labelFamilyStatus: UILabel!
    @IBOutlet weak var imageChevron: UIImageView!
    @IBOutlet weak var buttonOptions: UIButton!
    @IBOutlet weak var containerView: ACView!
    
    weak var delegate : MemberCellDelegate?
    var data : MemberModel?{
        didSet{
            guard let data = data else{return}
            setupData(data: data)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupData(data : MemberModel){
        if data.imageUser.isEmpty || data.imageUser == "" {
            self.imageUser.image = UIImage(named: "IconAltea")
        } else {
            if let urlPhotoPerson = URL(string: data.imageUser) {
                self.imageUser.kf.setImage(with: urlPhotoPerson)
            }
        }
        if data.isMainProfile == true{
            self.buttonOptions.isHidden = true
        }
        
        self.labelUserName.text = data.name
        self.labelFamilyStatus.text = data.role
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func optionTapped(_ sender: Any) {
        guard let id = data?.idMember else{return}
        delegate?.option(id: id)
    }
}
