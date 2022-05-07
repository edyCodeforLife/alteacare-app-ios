//
//  AddressOptionVC.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 31/08/21.
//

import UIKit
import PanModal

protocol AddressOptionDelegate : NSObject {
    func changeToPrimaryAddress(id : String)
    func deleteAddress(id : String)
}

class AddressOptionVC: UIViewController, PanModalPresentable {

    @IBOutlet weak var changePrimaryAddressButton: ACButton!
    @IBOutlet weak var deleteButton: ACButton!
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
    
    weak var delegate : AddressOptionDelegate?
    
    var idAddress: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.setupView()
        // Do any additional setup after loading the view.
    }
    
    func setupView(){
        changePrimaryAddressButton.set(type: .bordered(custom: .alteaMainColor), title: "Jadikan Alamat Utama")
        changePrimaryAddressButton.onTapped = {
            self.dismiss(animated: true, completion: nil)
            self.delegate?.changeToPrimaryAddress(id : self.idAddress ?? "")
        }
        
        deleteButton.set(type: .redButtonText, title: "Hapus")
        deleteButton.onTapped = {
            self.dismiss(animated: true, completion: nil)
            self.delegate?.deleteAddress(id: self.idAddress ?? "")
        }
    }

}
