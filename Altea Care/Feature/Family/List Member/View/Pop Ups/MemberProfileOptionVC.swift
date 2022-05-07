//
//  MemberProfileOptionVC.swift
//  Altea Care
//
//  Created by Tiara on 12/08/21.
//

import UIKit
import PanModal

protocol MemberProfileOptionDelegate: NSObject {
    func profileToAcc(id: String)
}

class MemberProfileOptionVC: UIViewController, PanModalPresentable {
    @IBOutlet weak var mainAccButton: ACButton!
    var panScrollable: UIScrollView?
    
    var isShortFormEnabled = true
    
    var showDragIndicator: Bool {
        return false
    }
    
    var shortFormHeight: PanModalHeight{
        .contentHeight(150.0)
    }
    
    var longFormHeight: PanModalHeight {
        return .contentHeight(191.0)
    }
    
    weak var delegate: MemberProfileOptionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainAccButton.set(type: .bordered(custom: .alteaMainColor), title: "Jadikan Profil Utama")
        mainAccButton.onTapped = {
            self.dismiss(animated: true, completion: nil)
            self.delegate?.profileToAcc(id: "")
        }
        // Do any additional setup after loading the view.
    }
}
