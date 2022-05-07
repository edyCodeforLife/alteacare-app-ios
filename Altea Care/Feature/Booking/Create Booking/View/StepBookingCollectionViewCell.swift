//
//  StepBookingCollectionViewCell.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 08/04/21.
//

import UIKit

class StepBookingCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var labelStepNumber: UILabel!
    @IBOutlet weak var viewLine: UIView!
    @IBOutlet weak var labelStepTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        circeView(view: containerView)
    }
    
    func circeView(view : UIView) {
        view.layer.masksToBounds = true
        view.layer.cornerRadius = view.bounds.width / 2
    }
}
