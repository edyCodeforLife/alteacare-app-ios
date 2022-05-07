//
//  ReceiptMedicinesCell.swift
//  Altea Care
//
//  Created by Admin on 15/3/21.
//

import UIKit

class ReceiptMedicinesCell: UITableViewCell {

    @IBOutlet weak var title: ACLabel!
    @IBOutlet weak var value: ACLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupUI() {
        title.textColor = .alteaDark2
        value.textColor = .alteaDark2
    }
    
    func setCell(model: MedicinesModel) {
        title.text = model.name
        value.text = "Rp \(model.price ?? "-")"
    }
    
}
