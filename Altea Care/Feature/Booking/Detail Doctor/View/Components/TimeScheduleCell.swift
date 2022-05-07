//
//  TimeScheduleCell.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 24/03/21.
//

import UIKit

class TimeScheduleCell: UICollectionViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var labelScheduleTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override var isSelected: Bool {
        didSet {
            if self.isSelected {
                self.setupBackgroundColorSelected()
            } else {
                self.setupBackgroundColorDeselected()
            }
        }
    }
    
    //MARK: - Setup Cell Data
    //For a while using dummy
    func setupCellTime(model : DoctorScheduleDataModel){
        self.labelScheduleTime.text = "\(model.startTime) - \(model.endTime)"
    }
    
    func setupBackgroundColorSelected(){
        containerView.backgroundColor = UIColor.alteaMainColor
        labelScheduleTime.textColor = UIColor.white
    }
    
    func setupBackgroundColorDeselected(){
        containerView.backgroundColor = UIColor.white
        labelScheduleTime.textColor = UIColor.alteaMainColor
    }
}
