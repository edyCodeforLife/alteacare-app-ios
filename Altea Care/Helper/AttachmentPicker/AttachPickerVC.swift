//
//  AttachPickerVC.swift
//  Altea Care
//
//  Created by Hedy on 18/03/21.
//

import UIKit
import PanModal

protocol AttachmentPickerDelegate: NSObject {
    func gallerySelected()
    func camSelected()
    func docSelected()
}

class AttachPickerVC: UIViewController,PanModalPresentable {

    @IBOutlet weak var openGaleryButton: ACButton!
    @IBOutlet weak var cameraButton: ACButton!
    @IBOutlet weak var docButton: ACButton!
    
    weak var delegate: AttachmentPickerDelegate?
    
    var panScrollable: UIScrollView?
    
    var isShortFormEnabled = true
    
    var showDragIndicator: Bool {
        return false
    }
    
    var shortFormHeight: PanModalHeight {
        .contentHeight(247.0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
    }
    
    private func setupView(){
        openGaleryButton.set(type: .bordered(custom: .alteaMainColor), title: "Buka Galeri")
        cameraButton.set(type: .bordered(custom: .alteaMainColor), title: "Kamera")
        docButton.set(type: .bordered(custom: .alteaMainColor), title: "Dokumen")
        openGaleryButton.onTapped = {
            self.dismiss(animated: true, completion: nil)
            self.delegate?.gallerySelected()
        }
        
        cameraButton.onTapped = {
            self.dismiss(animated: true, completion: nil)
            self.delegate?.camSelected()
        }
        
        docButton.onTapped = {
            self.dismiss(animated: true, completion: nil)
            self.delegate?.docSelected()
        }
    }
    
}
