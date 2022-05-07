//
//  UnableToUpdateProfileVC.swift
//  Altea Care
//
//  Created by Tiara on 12/08/21.
//

import UIKit
import PanModal

protocol UnableToUpdateProfileDelegate: NSObject {
    func contactCustomerCare()
}

class UnableToUpdateProfileVC: UIViewController,PanModalPresentable {
    
    @IBOutlet weak var contactButton: ACButton!
    
    weak var delegate: UnableToUpdateProfileDelegate?
    
    var panScrollable: UIScrollView?
    var isShortFormEnabled = true
    
    var showDragIndicator: Bool{
        return false
    }
    
    var shortFormHeight: PanModalHeight{
        .contentHeight(400.0)
    }
    
    var anchorModalToLongForm: Bool {
        return false
    }
    
    var isUserInteractionEnabled: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contactButton.set(type: .bordered(custom: .alteaMainColor), title: "Hubungi Layanan Pelanggan")
        contactButton.onTapped = { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true, completion: nil)
            self.delegate?.contactCustomerCare()
        }
        // Do any additional setup after loading the view.
    }
    
}
