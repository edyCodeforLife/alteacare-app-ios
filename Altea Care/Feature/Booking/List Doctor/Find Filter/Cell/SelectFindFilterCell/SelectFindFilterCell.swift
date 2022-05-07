//
//  SelectFindFilterCell.swift
//  Altea Care
//
//  Created by Nur Irfan Pangestu on 29/12/21.
//

import UIKit

class SelectFindFilterCell: UITableViewCell {
    @IBOutlet weak var titleLabel: ACLabel!
    @IBOutlet weak var containerCheckbox: UIView!
    @IBOutlet weak var buttonCheckbox: UIImageView!
    
    @IBOutlet weak var containerExpandableIcon: UIView!
    @IBOutlet weak var expandableIcon: UIImageView!
    
    @IBOutlet weak var containerLeadConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerTrailConstraint: NSLayoutConstraint!
    
    var filterData: FilterList? {
        didSet {
            self.titleLabel.text = filterData?.name
            self.containerExpandableIcon.isHidden = (filterData?.subFilter.isEmpty ?? true) ? true : false
            self.expandableIcon.image = (filterData?.isOpen ?? false) ? UIImage(named: "chevronUpTriangle") : UIImage(named: "chevronDownTriangle")
            self.buttonCheckbox.image = (filterData?.isChecked ?? false) ? UIImage(named: "ChecklistDoctor") : nil
        }
    }
    
    var onChecklistTapped: ((Bool) -> Void)?
    var onExpandTapped: ((Bool) -> Void)?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        containerLeadConstraint.constant = 18
        containerTrailConstraint.constant = 18
        titleLabel.font = .font(size: 14, fontType: .normal)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.titleLabel.textColor = UIColor(hexString: "3A3A3C")
        self.titleLabel.font = .font(size: 14, fontType: .normal)
        self.titleLabel.numberOfLines = 0
        self.containerCheckbox.layer.cornerRadius = 3
        self.containerCheckbox.layer.borderWidth = 1
        self.containerCheckbox.layer.borderColor = UIColor(hexString: "8F90A6").cgColor
        self.buttonCheckbox.clipsToBounds = true
        self.containerExpandableIcon.isHidden = true
        
        self.containerExpandableIcon.addTapGestureRecognizer {
            guard let filter = self.filterData else {return}
            self.onExpandTapped?(!filter.isOpen)
        }

        self.buttonCheckbox.addTapGestureRecognizer {
            guard let filter = self.filterData else {return}
            self.onChecklistTapped?(!filter.isChecked)

        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setToChildCell() {
        containerLeadConstraint.constant = 36
        containerTrailConstraint.constant = 36
        titleLabel.font = .font(size: 12, fontType: .normal)
    }
}
