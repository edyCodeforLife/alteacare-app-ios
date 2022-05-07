//
//  AttachedFileCell.swift
//  Altea Care
//
//  Created by Admin on 9/3/21.
//

import UIKit

class AttachedFileCell: UITableViewCell {

    @IBOutlet weak var fileName: ACLabel!
    @IBOutlet weak var fileSize: ACLabel!
    @IBOutlet weak var previewButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    var previewTapped: (() -> Void)?
    var deleteTapped: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupUI()
        self.previewAction()
        self.deleteAction()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupUI() {
        self.fileName.textColor = .alteaDark1
        self.fileSize.textColor = .alteaDark3
        self.previewButton.titleLabel?.font = UIFont(name: "Inter-Black", size: 15)
        self.previewButton.titleLabel?.tintColor = .alteaMainColor
        
        self.deleteButton.titleLabel?.font = UIFont(name: "Inter-Black", size: 15)
        self.deleteButton.titleLabel?.tintColor = .alteaRedMain
    }
    
    private func previewAction() {
        self.previewButton.addTapGestureRecognizer {
            self.previewTapped?()
        }
    }
    
    private func deleteAction() {
        self.deleteButton.addTapGestureRecognizer {
            self.deleteTapped?()
        }
    }
    
    func setAttachmentFile(documents: MedicalDocumentItem) {
        self.fileName.text = documents.title
        self.fileSize.text = documents.size
    }

    
    
}
