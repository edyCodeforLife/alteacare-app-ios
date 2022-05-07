//
//  PopAddAccountVC.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 09/09/21.
//

import UIKit
import PanModal

protocol PopAddDelegate : AnyObject {
    func goToCreateAccount()
    func goToLogin()
}

class PopAddAccountVC: UIViewController, PanModalPresentable{
    
    var panScrollable: UIScrollView?
    var isShortFormEnabled = false
    var shortFormHeight: PanModalHeight{
        .contentHeight(150)
    }
    var showDragIndicator: Bool {
        return false
    }
    
    var longFormHeight: PanModalHeight {
        return .contentHeight(200)
    }
    
    
    weak var delegate : PopAddDelegate?

    @IBOutlet weak var buttonSignIn: ACButton!
    @IBOutlet weak var buttonCreateNewAccount: ACButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        buttonSignIn.set(type: .bordered(custom: .info), title: "Masuk dengan Akun Terdaftar")
        buttonSignIn.onTapped = { [weak self] in
            guard let self = self else { return }
            self.delegate?.goToLogin()
        }
        
        buttonCreateNewAccount.set(type: .bordered(custom: .info), title: "Buat Akun Baru")
        buttonCreateNewAccount.onTapped = { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true, completion: nil)
            self.delegate?.goToCreateAccount()
        }
    }
}
