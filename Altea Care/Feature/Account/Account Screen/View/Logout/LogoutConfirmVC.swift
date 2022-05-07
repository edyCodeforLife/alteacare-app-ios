//
//  LogoutConfirmVC.swift
//  Altea Care
//
//  Created by Ridwan Abdurrasyid on 01/03/22.
//


//
//  ClosePaymentConfirmationVC.swift
//  Altea Care
//
//  Created by Ridwan Abdurrasyid on 22/02/22.
//

import UIKit
import PanModal

class LogoutConfirmVC: UIViewController {

    @IBOutlet weak var confirmationLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var approveButton: UIButton!
    
    var onApproveTapped: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    func setupUI() {
        self.setupSecondaryButton(button: self.approveButton)
        self.setupSecondaryButton(button: self.cancelButton)
    }
    
    @IBAction func onCancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onApproveTapped(_ sender: Any) {
        self.dismiss(animated: true) {
            self.onApproveTapped?()
        }
    }
    
}

extension LogoutConfirmVC : PanModalPresentable{
    var panScrollable: UIScrollView? {
        return nil
    }
    
    var longFormHeight: PanModalHeight {
        return .maxHeightWithTopInset(100)
    }
    var anchorModalToLongForm: Bool {
        return false
    }
    var showDragIndicator: Bool {
        return false
    }
    var shortFormHeight: PanModalHeight {
        return .contentHeight(180)
    }
}

