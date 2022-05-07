//
//  EmptyDocumentCell.swift
//  Altea Care
//
//  Created by Admin on 18/3/21.
//

import UIKit

class EmptyDocumentCell: UITableViewCell {

    @IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var label: ACLabel!
    @IBOutlet weak var containerView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.containerView.frame.size.height = UIScreen.main.bounds.height/2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(model: EmptyDocumentModel) {
        
        
        switch model.label {
        case .medResumeOnProcess:
            self.label.textColor = .alteaBlueMain
            self.imageIcon.image = #imageLiteral(resourceName: "dokumenMedis")
            self.label.text = model.label.text
        case .noMedResume:
            self.label.textColor = .alteaDark2
            self.imageIcon.image = #imageLiteral(resourceName: "dokumenMedis")
            self.label.text = model.label.text
        case .noDocument:
            self.label.textColor = .alteaDark2
            self.imageIcon.image = #imageLiteral(resourceName: "dokumenIcon")
            self.label.text = model.label.text
        }
    }
    
}

struct EmptyDocumentModel {
    let label: EmptyDocumentItems
}

enum EmptyDocumentItems {
    case medResumeOnProcess
    case noMedResume
    case noDocument
    
    var text: String {
        switch self {
        case .medResumeOnProcess:
            return "Resume medis sedang dalam proses"
        case .noMedResume:
            return "Belum ada resume medis disini"
        case .noDocument:
            return "Belum ada dokumen medis disini"
        }
    }
}

