//
//  DeleteConfirmVC.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 08/09/21.
//

import UIKit
import PanModal

protocol DeleteConfirmDelegate : NSObject {
    func delete(id : String)
    func backToVC()
}

class DeleteConfirmVC: UIViewController, PanModalPresentable {
    
    @IBOutlet weak var buttonDelete: ACButton!
    @IBOutlet weak var buttonBack: ACButton!
    
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
    
    weak var delegate : DeleteConfirmDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //If needed, configure on next dev
        buttonBack.set(type: .bordered(custom: .red), title: "Batal")
        buttonBack.onTapped = {
            self.dismiss(animated: true, completion: nil)
        }
        
        buttonDelete.set(type: .bordered(custom: .alteaBlueMain), title: "Yakin")
        buttonDelete.onTapped = {
            self.dismiss(animated: true, completion: nil)
            self.delegate?.delete(id: "")
        }
    }

}
