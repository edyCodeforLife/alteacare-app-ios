//
//  SectionCell.swift
//  Altea Care
//
//  Created by Admin on 16/3/21.
//

import UIKit

class SectionCell: UITableViewCell {

    @IBOutlet weak var background: UIView!
    @IBOutlet weak var label: ACLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupUI() {
        background.backgroundColor = .alteaDark2
        label.textColor = .alteaBlueMain
    }
    
    func setCell(title: String) {
        label.text = title
    }
    
}
