//
//  AttachFileCell.swift
//  Altea Care
//
//  Created by Admin on 9/3/21.
//

import UIKit

class AttachFileCell: UITableViewCell {

    @IBOutlet weak var attachFileBar: AttachFileBar!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        self.attachFileBar.attachFile.addTapGestureRecognizer {
            print("attach file button tapped")
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
