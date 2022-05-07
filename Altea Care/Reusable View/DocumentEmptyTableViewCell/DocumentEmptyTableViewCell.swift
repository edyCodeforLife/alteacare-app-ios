//
//  DocumentEmptyTableViewCell.swift
//  Altea Care
//
//  Created by Rahmad Hidayat on 08/07/21.
//

import UIKit

class DocumentEmptyTableViewCell: UITableViewCell {

    @IBOutlet weak var buttonRefresh: ACButton!
    
    var buttonTapped: (() -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupUI(){
        self.buttonRefresh.set(type: .filled(custom: .alteaMainColor), title: "Refresh")
        self.buttonRefresh.addTapGestureRecognizer {
            self.buttonTapped?()
        }
    }
    
}
