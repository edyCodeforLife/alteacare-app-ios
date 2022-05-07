//
//  PreviewAddedFamVC.swift
//  Altea Care
//
//  Created by Tiara on 11/08/21.
//

import UIKit
import PanModal

protocol ProfilePreviewDelegate: NSObject {
    func continueProcess()
}

class PreviewAddedFamVC: UIViewController, PanModalPresentable {
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var dobLabel: UILabel!
    @IBOutlet weak var birthPlaceLabel: UILabel!
    @IBOutlet weak var citizenshipLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var continueButton: ACButton!
    @IBOutlet weak var changeButton: ACButton!
    
    weak var delegate: ProfilePreviewDelegate?
    
    var panScrollable: UIScrollView?
    
    var isShortFormEnabled = true
    
    var shortFormHeight: PanModalHeight{
        .contentHeight(564.0)
    }
    
    var longFormHeight: PanModalHeight {
        return .contentHeight(564.0)
    }
    
    var userName: String?
    var dob: String?
    var birthPlace: String?
    var citizenship: String?
    var gender: String?
    convenience init(name: String, dob: String, birth: String, citizenship: String, gender: String) {
        self.init()
        self.userName = name
        self.dob = dob
        self.birthPlace = birth
        self.citizenship = citizenship
        self.gender = gender
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    private func setupUI(){
        
        userNameLabel.text = userName
        dobLabel.text = dob
        birthPlaceLabel.text = birthPlace
        citizenshipLabel.text = citizenship
        genderLabel.text = gender
        
        continueButton.set(type: .filled(custom: .alteaMainColor), title: "Lanjutkan")
        changeButton.set(type: .bordered(custom: .alteaMainColor), title: "Ubah")
        continueButton.onTapped = { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true, completion: nil)
            self.delegate?.continueProcess()
        }
        
        changeButton.onTapped = { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true, completion: nil)
            
        }
    }
}
