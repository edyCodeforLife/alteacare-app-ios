//
//  ReconsultationVC.swift
//  Altea Care
//
//  Created by Hedy on 18/12/21.
//

import UIKit

class ReconsultationVC: UIViewController, ReconsultationView {
    
    var onReconsultationTapped: (() -> Void)?
    var onCancel: ((String) -> Void)?
    var onClose: (() -> Void)?
    
    @IBOutlet private weak var headerLabel: ACLabel!
    @IBOutlet private weak var problemLabel: ACLabel!
    @IBOutlet private weak var infoLabel: ACLabel!
    @IBOutlet private weak var reconsultationButton: ACButton!
    @IBOutlet private weak var cancelButton: ACButton!
    
    @IBAction func onCloseTapped(_ sender: Any) {
        self.onClose?()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        setupLabel()
        setupAttrLabel()
        setupButton()
    }
    
    private func setupLabel() {
        self.headerLabel.font = .font(size: 18, fontType: .bold)
        self.problemLabel.font = .font(size: 18, fontType: .bold)
    }
    
    private func setupAttrLabel() {
        let attrs1 = [NSAttributedString.Key.font : UIFont.font(), NSAttributedString.Key.foregroundColor : UIColor.alteaRedMain]
        let attrs2 = [NSAttributedString.Key.font : UIFont.font(size: 14, fontType: .bold), NSAttributedString.Key.foregroundColor : UIColor.alteaRedMain]
        let attributedString1 = NSMutableAttributedString(string:"Pastikan", attributes:attrs1)
        let attributedString2 = NSMutableAttributedString(string:" baterai dan koneksi internet stabil ", attributes:attrs2)
        let attributedString3 = NSMutableAttributedString(string:"agar telekonsultasi berjalan lancar", attributes:attrs1)
        attributedString1.append(attributedString2)
        attributedString1.append(attributedString3)
        self.infoLabel.attributedText = attributedString1
    }
    
    private func setupButton() {
        reconsultationButton.set(type: .filled(custom: nil), title: "Hubungkan Lagi", titlePosition: nil, font: .font(size: 16, fontType: .bold), icon: nil, iconPosition: nil)
        reconsultationButton.clipsToBounds = true
        reconsultationButton.onTapped = { [weak self] in
            guard let self = self else { return }
            self.onReconsultationTapped?()
        }
        cancelButton.set(type: .bordered(custom: UIColor.alteaDark3), title: "Batalkan Panggilan", titlePosition: nil, font: .font(size: 16, fontType: .bold), icon: nil, iconPosition: nil)
        cancelButton.clipsToBounds = true
        cancelButton.onTapped = { [weak self] in
            guard let self = self else { return }
            self.cancelPopup()
        }
    }
    
    private func cancelPopup() {
        let cancelModal = CallCancelConfirmationModal()
        cancelModal.onConfirmed = { [weak self] (reason) in
            guard let self = self else { return }
            cancelModal.dismiss(animated: true, completion: nil)
            self.onCancel?(reason)
        }
        presentPanModal(cancelModal)
    }
    
    func bindViewModel() { }

}
