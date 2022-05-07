//
//  EmptyStateCell.swift
//  Altea Care
//
//  Created by Admin on 17/3/21.
//

import UIKit

class EmptyStateCell: UITableViewCell {

    @IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var label: ACLabel!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupUI() {
        self.imageIcon.image = #imageLiteral(resourceName: "spesialis inactive")
        self.label.textColor = .alteaDark3
        self.containerView.layer.cornerRadius = 6
        self.containerView.layer.cornerRadius = 6
        self.containerView.layer.shadowColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1) //UIColor.alteaDark1.cgColor
        self.containerView.layer.shadowOpacity = 3
        self.containerView.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.containerView.layer.shadowRadius = 2
    }
    
    func setupEmptyCell(page: String?) {
        if page == "ongoing" {
            self.label.text = "Tidak ada telekonsultasi disini"
        } else if page == "history" {
            self.label.text = "Tidak ada riwayat telekonsultasi"
        } else if page == "cancel" {
            self.label.text = "Tidak ada telekonsultasi yang dibatalkan"
        } else if page == "doctor" {
            self.label.text = "Dokter tidak ditemukan"
        }
    }
    
}
