//
//  MedicalDocumentCell.swift
//  Altea Care
//
//  Created by Admin on 11/3/21.
//

import UIKit

class MedicalDocumentCell: UITableViewCell {

    @IBOutlet weak var fileName: ACLabel!
    @IBOutlet weak var size: ACLabel!
    @IBOutlet weak var date: ACLabel!
    @IBOutlet weak var previewButton: ACLabel!
    
    var buttonTapped: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setDocumentCell(model: MedicalDocumentItem) {
        self.fileName.text = model.title
        self.size.text = model.size
        self.date.text = model.date
    }
    
    private func setupUI() {
        self.fileName.textColor = .alteaDark1
        self.size.textColor = .alteaDark3
        self.date.textColor = .alteaDark3
        self.previewButton.textColor = .alteaDarker
        self.previewButton.addTapGestureRecognizer {
            self.buttonTapped?()
        }
        self.previewButton.font = .font(size: 15, fontType: .bold)
    }
    
}
