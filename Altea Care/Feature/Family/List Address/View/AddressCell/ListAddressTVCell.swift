//
//  DaftarAlamatTVCell.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 20/08/21.
//

import UIKit

protocol ListAddressTVCellDelegate: AnyObject {
    func option(id : String)
    func editAddress(data : DetailAddressModel, idSelected : String)
}

class ListAddressTVCell: UITableViewCell {

    @IBOutlet weak var containerView: ACView!
    @IBOutlet weak var buttonChange: UIButton!
    @IBOutlet weak var buttonOptions: UIButton!
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var viewAddresStatus: ACView!
    @IBOutlet weak var labelAddressStatus: UILabel!
    
    weak var delegate : ListAddressTVCellDelegate?
    
    var idAddressSelected : String?
    var idCountry : String?
    var idProvince : String?
    var idCity : String?
    var idDistrict : String?
    var idSubDistrict : String?
    var data : DetailAddressModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupData(data : DetailAddressModel){
        self.labelAddress.text = "\(data.street)\n\(data.rtRw), \(data.subDistrict), \(data.district)\n\(data.city), \(data.province)"
        self.idAddressSelected = data.id
        self.data = data
        self.idCountry = data.idCountry
        if data.type == "REGULAR" {
            self.viewAddresStatus.isHidden = true
            self.labelAddressStatus.isHidden = true
            self.buttonOptions.isHidden = false
        } else {
            self.labelAddressStatus.isHidden = false
            self.viewAddresStatus.isHidden = false
            self.buttonOptions.isHidden = true
            self.labelAddressStatus.text = data.type
        }
    }
    
    @IBAction func optionTapped(_ sender: Any) {
        delegate?.option(id: idAddressSelected ?? "")
    }
    
    @IBAction func editAddress(_ sender: Any) {
        delegate?.editAddress(data: data ?? DetailAddressModel(id: "", type: "", street: "", rtRw: "", country: "", province: "", city: "", district: "", subDistrict: "", latitude: "", longitude: "", idCity: "", idProvince: "", idDistrict: "", idCountry: "", idSubDistrict: ""), idSelected: self.idAddressSelected ?? "")
    }
    
}
