//
//  AddProfileAsAccountVC.swift
//  Altea Care
//
//  Created by Tiara on 12/08/21.
//

import UIKit
import PanModal

protocol AddProfileAsAccountDelegate: NSObject {
    func registProfile()
    func denyRegist()
}


class AddProfileAsAccountVC: UIViewController, PanModalPresentable {
    var panScrollable: UIScrollView?
    
    @IBOutlet weak var registProfileButton: ACButton!
    @IBOutlet weak var denyButton: ACButton!
    
    weak var delegate: AddProfileAsAccountDelegate?
    
    var isShortFormEnabled = false
    var shortFormHeight: PanModalHeight{
        .contentHeight(332.0)
    }
    
    var longFormHeight: PanModalHeight {
        return .contentHeight(332.0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }
    
    private func setupUI(){
        registProfileButton.set(type: .bordered(custom: .alteaMainColor), title: "Daftarkan sebagai Akun")
        denyButton.set(type: .filled(custom: .alteaMainColor), title: "Tidak, daftarkan Profil keluarga saja")
        registProfileButton.onTapped = { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true, completion: nil)
            self.delegate?.registProfile()
        }
        
        denyButton.onTapped = { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true, completion: nil)
            self.delegate?.denyRegist()
        }
    }


}
