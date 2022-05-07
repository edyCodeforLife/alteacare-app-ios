//
//  ErrorPaymentVC.swift
//  Altea Care
//
//  Created by Nur Irfan Pangestu on 24/01/22.
//

import UIKit
import PanModal

protocol ErrorPaymentDelegate: NSObject {
    
}

class ErrorPaymentVC: UIViewController, PanModalPresentable {
    
    weak var delegate: ErrorPaymentDelegate?
    var panScrollable: UIScrollView?
    
    var showDragIndicator: Bool {
        return false
    }
    
    var shortFormHeight: PanModalHeight {
        .contentHeight(275)
    }
    
    var longFormHeight: PanModalHeight {
        .contentHeight(275)
    }
    
    @IBOutlet weak var errorImage: UIImageView!
    @IBOutlet weak var errorLbl: UILabel!
    @IBOutlet weak var submitBtn: ACButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupAction()
    }
    
    private func setupUI() {
        self.errorLbl.text = "Anda belum melakukan pembayaran,\nStatus Anda belum terkonfirmasi"
        self.submitBtn.set(type: .filled(custom: UIColor(hexString: "#3E8CB9")), title: "Oke")
        self.submitBtn.layer.cornerRadius = 8
    }
    
    private func setupAction() {
        self.submitBtn.onTapped = { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
}
