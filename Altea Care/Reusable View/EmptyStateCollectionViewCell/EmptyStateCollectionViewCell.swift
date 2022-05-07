//
//  EmptyStateCollectionViewCell.swift
//  Altea Care
//
//  Created by Rahmad Hidayat on 27/06/21.
//

import UIKit
import FSPagerView

class EmptyStateCollectionViewCell: FSPagerViewCell {
    @IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var label: ACLabel!
    @IBOutlet weak var containerView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupUI()
    }
    
    private func setupUI() {
        self.imageIcon.image = #imageLiteral(resourceName: "spesialis inactive")
        self.label.textColor = .alteaDark3
    }
    
    func setupEmptyCell(page: String?) {
        if page == "ongoing" {
            self.label.text = "Tidak ada jadwal telekonsultasi "
        } else if page == "history" {
            self.label.text = "Tidak ada riwayat telekonsultasi"
        } else if page == "cancel" {
            self.label.text = "Tidak ada telekonsultasi yang dibatalkan"
        } else if page == "doctor" {
            self.label.text = "Mohon maaf doktor tidak ada"
        } else if page == "ongoingToday" {
            self.label.text = "Tidak ada telekonsultasi hari ini"
        }
    }

}
