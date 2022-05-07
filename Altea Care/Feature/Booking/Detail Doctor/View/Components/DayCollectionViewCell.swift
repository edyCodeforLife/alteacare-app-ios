//
//  DayCollectionViewCell.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 26/03/21.
//

import UIKit

class DayCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    
    override var isSelected: Bool {
        didSet {
            if self.isSelected {
                self.setupBackgroundColorSelected()
            } else {
                self.setupBackgroundColorDeselected()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupDay(day: String) {
        self.dayLabel.text = day
    }
    
    func setupDay(model: DayName) {
        self.dayLabel.text = model.day
    }
    
    func setupDay(name: String){
        self.dayLabel.text = name
    }
    
    func setupBackgroundColorSelected(){
        backView.backgroundColor = UIColor.info
        dayLabel.textColor = UIColor.white
    }
    
    func setupBackgroundColorDeselected(){
        backView.backgroundColor = UIColor.white
        dayLabel.textColor = UIColor.info
    }
}

extension DayCollectionViewCell {
    func toogleSelected() {
        if (isSelected){
            backView.backgroundColor = UIColor.info
            dayLabel.textColor = UIColor.white
        }else {
            backView.backgroundColor = UIColor.white
            dayLabel.textColor = UIColor.info
        }
    }
}
