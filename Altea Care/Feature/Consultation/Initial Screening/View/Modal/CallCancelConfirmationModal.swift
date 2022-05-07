//
//  CallCancelConfirmationModal.swift
//  Altea Care
//
//  Created by Hedy on 27/12/21.
//

import UIKit
import PanModal

class CallCancelConfirmationModal: UIViewController, PanModalPresentable {
    
    var panScrollable: UIScrollView?
    
    var onConfirmed: ((String) -> Void)?
    var onCancel: (() -> Void)?
    private var reason: String?
    
    @IBOutlet weak var confirmButton: ACButton!
    @IBOutlet weak var cancelButton: ACButton!
    
    var showDragIndicator: Bool {
        return false
    }
    
    var shortFormHeight: PanModalHeight {
        .contentHeight(270)
    }
    
    var longFormHeight: PanModalHeight {
        return .contentHeight(270)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupButton()
    }
    
    private func setupButton() {
        confirmButton.set(type: .bordered(custom: UIColor.alteaDark3), title: "Ya, Batalkan Panggilan", titlePosition: nil, font: .font(size: 16, fontType: .bold), icon: nil, iconPosition: nil)
        confirmButton.clipsToBounds = true
        confirmButton.onTapped = { [weak self] in
            guard let self = self else { return }
            let vc = CallCancelReasonModal()
            vc.onSelected = { [weak self] (reason) in
                guard let self = self else { return }
                vc.dismiss(animated: true) {
                    self.reason = reason
                    self.onConfirmed?(reason)
                }
            }
            self.presentPanModal(vc)
        }
        cancelButton.set(type: .filled(custom: nil), title: "Tidak", titlePosition: nil, font: .font(size: 16, fontType: .bold), icon: nil, iconPosition: nil)
        cancelButton.clipsToBounds = true
        cancelButton.onTapped = { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true)
            self.onCancel?()
        }
    }
    
    func panModalDidDismiss() {
        if self.reason == nil {
            self.onCancel?()
        }
    }

}
