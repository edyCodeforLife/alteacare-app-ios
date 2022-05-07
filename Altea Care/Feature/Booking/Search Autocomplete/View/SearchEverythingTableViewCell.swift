//
//  SearchEverythingTableViewCell.swift
//  Altea Care
//
//  Created by Rahmad Hidayat on 08/07/21.
//

import UIKit

class SearchEverythingTableViewCell: UITableViewCell {

    @IBOutlet weak var lbName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        lbName.textColor = .alteaDark1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup(target: String, isRoot: Bool) {
        self.lbName.text = target
    }
    
}
