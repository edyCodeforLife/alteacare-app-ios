//
//  OutsideOperatingHourViewController.swift
//  Altea Care
//
//  Created by Galang Aji Susanto on 28/11/21.
//

import UIKit
import PanModal

class OutsideOperatingHourViewController: UIViewController, OutsideOperatingHourView {
    
    var onBackPressed: (() -> Void)?
    var onOkPressed: (() -> Void)?
    var setting: SettingModel?

    @IBOutlet weak var illustrationImage: UIImageView!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var officeHourLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindView()
    }
    func bindViewModel() {}
    
    private func bindView() {
        if let settingData = setting {
            officeHourLabel.text = "Setiap hari dari pukul \(settingData.operationalHourStart)-\(settingData.operationalHourEnd) WIB"
        }
        okButton.setupPrimaryButton(title: "Ok, Mengerti"){
        
        }
        
    }
    @IBAction func okButtonTapped(_ sender: UIButton) {
        self.onOkPressed?()
    }
    @objc
    func backAction(sender : UITapGestureRecognizer) {
        self.onBackPressed?()
    }
}

extension OutsideOperatingHourViewController : PanModalPresentable{
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
        return .contentHeight(500)
    }
}
