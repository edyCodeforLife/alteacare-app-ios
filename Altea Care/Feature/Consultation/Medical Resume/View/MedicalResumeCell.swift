//
//  MedicalResumeCell.swift
//  Altea Care
//
//  Created by Admin on 11/3/21.
//

import UIKit

class MedicalResumeCell: UITableViewCell {

    var linkOnTapped: (() -> Void)?
    
    @IBOutlet weak var title: ACLabel!
    @IBOutlet weak var textView: ACLabel!
    @IBOutlet weak var separator: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupUI() {
        
        self.title.textColor = .alteaDark1
        self.textView.textColor = .alteaDark3
        self.title.font = .font(size: 15, fontType: .bold)
    }
    
    func setValueText(model: MedicalResumeModel, isLast: Bool) {
        self.title.text = model.title
        self.textView.text = model.textViewText
        self.separator.isHidden = isLast
    }
}
