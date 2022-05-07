//
//  RightImageCell.swift
//  Altea Care
//
//  Created by Tiara on 16/03/21.
//

import UIKit

class RightImageCell: UITableViewCell {
    @IBOutlet weak var messageIV: UIImageView!
    @IBOutlet weak var bubbleChatView: ACView!
    @IBOutlet weak var playIndicatorIV: UIImageView!
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    
    var currentRow:Int? = nil
    weak var delegate: ImageCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    func updateView(){
        guard let image = messageIV.image else { return }
        let height = (image.size.height/image.size.width)*messageIV.frame.width
        imageHeightConstraint.constant = height
        delegate?.reload(row: currentRow)
    }
    
}
