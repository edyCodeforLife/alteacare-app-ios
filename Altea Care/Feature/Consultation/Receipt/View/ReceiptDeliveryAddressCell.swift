//
//  ReceiptDeliveryAddressCell.swift
//  Altea Care
//
//  Created by Admin on 15/3/21.
//

import UIKit

class ReceiptDeliveryAddressCell: UITableViewCell {

    @IBOutlet weak var name: ACLabel!
    @IBOutlet weak var phone: ACLabel!
    @IBOutlet weak var address: ACLabel!
    @IBOutlet weak var courier: ACLabel!
    @IBOutlet weak var fee: ACLabel!
    @IBOutlet weak var pengiriman: ACLabel!
    @IBOutlet weak var biaya: ACLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupUI() {
        name.textColor = .alteaDark1
        phone.textColor = .alteaDark1
        address.textColor = .alteaDark2
        courier.textColor = .alteaDark2
        fee.textColor = .alteaDark2
        pengiriman.textColor = .alteaDark1
        biaya.textColor = .alteaDark2
        
        name.font = .font(size: 15, fontType: .bold)
        phone.font = .font(size: 15, fontType: .bold)
        pengiriman.font = .font(size: 15, fontType: .bold)
    }
    
    func setCell(model: RecipientModel) {
        name.text = model.name
        phone.text = model.phone
        address.text = model.address
        courier.text = model.courier
        fee.text = model.fee
    }
    
}
