//
//  StepBookingCell.swift
//  Altea Care
//
//  Created by Tiara on 12/04/21.
//

import UIKit

class StepBookingCell: UICollectionViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var labelStepNumber: UILabel!
    @IBOutlet weak var viewLine: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        circeView(view: containerView)
    }
    
    func circeView(view : UIView) {
        view.layer.masksToBounds = true
        view.layer.cornerRadius = view.bounds.width / 2
    }
    
    func isActiveView(){
        viewLine.backgroundColor = UIColor.alteaBlueMain
    }

}
