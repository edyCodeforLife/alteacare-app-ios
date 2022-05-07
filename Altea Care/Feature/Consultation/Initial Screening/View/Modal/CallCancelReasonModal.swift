//
//  CallCancelReasonModal.swift
//  Altea Care
//
//  Created by Hedy on 27/12/21.
//

import UIKit
import PanModal
import SimpleCheckbox

class CallCancelReasonModal: UIViewController, PanModalPresentable {
    
    var panScrollable: UIScrollView?
    
    var onSelected: ((String) -> Void)?
    private var options = ["Tidak sengaja membuat order", "Ingin ubah jadwal", "Ingin ubah Dokter Spesialis", "Lainnya"]
    
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var fourthLabel: UILabel!

    @IBOutlet weak var firstBox: Checkbox!
    @IBOutlet weak var secondBox: Checkbox!
    @IBOutlet weak var thirdBox: Checkbox!
    @IBOutlet weak var fourthBox: Checkbox!
    
    @IBOutlet weak var submitButton: ACButton!
    @IBOutlet weak var otherNotes: UITextView!
    @IBOutlet weak var containerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var textviewHeightConstraint: NSLayoutConstraint!
    
    private var boxes = [Checkbox]()
    private var labels = [UILabel]()
    
    var showDragIndicator: Bool {
        return false
    }
    
    var shortFormHeight: PanModalHeight {
        if let indexSelected = self.boxes.firstIndex(where: { $0.isChecked }) {
            if indexSelected == self.options.count - 1 {
                return .contentHeight(500)
            }
        }
        return .contentHeight(420)
    }
    
    var longFormHeight: PanModalHeight {
        if let indexSelected = self.boxes.firstIndex(where: { $0.isChecked }) {
            if indexSelected == self.options.count - 1 {
                return .contentHeight(500)
            }
        }
        return .contentHeight(420)
    }
    
    @IBAction func onCloseTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLabel()
        self.setupCheckbox()
        self.setupButton()
        self.setupTextview()
    }
    
    private func setupCheckbox() {
        boxes = [firstBox, secondBox, thirdBox, fourthBox]
        
        for i in 0..<boxes.count {
            boxes[i].checkmarkStyle = .circle
            boxes[i].checkedBorderColor = .primary
            boxes[i].uncheckedBorderColor = .primary
            boxes[i].borderStyle = .circle
            boxes[i].checkmarkColor = .info
            
            boxes[i].valueChanged = { (isChecked) in
                if isChecked {
                    self.resetCheckboxes(exclude: i)
                }
                self.setupButton()
                self.setTextviewState()
                self.panModalSetNeedsLayoutUpdate()
                self.panModalTransition(to: .shortForm)
            }
        }
    }
    
    private func setupLabel() {
        labels = [firstLabel, secondLabel, thirdLabel, fourthLabel]
        
        for i in 0..<labels.count {
            labels[i].text = options[i]
        }
    }
    
    private func resetCheckboxes(exclude: Int) {
        for i in 0..<boxes.count {
            boxes[i].isChecked = i == exclude
        }
    }
    
    private func setupButton() {
        self.setButtonState()
        submitButton.clipsToBounds = true
        submitButton.onTapped = { [weak self] in
            guard let self = self else { return }
            if let indexSelected = self.boxes.firstIndex(where: { $0.isChecked }) {
                let optionSelected = self.options[indexSelected]
                if indexSelected == self.options.count - 1 {
                    self.onSelected?(self.otherNotes.text)
                } else {
                    self.onSelected?(optionSelected)
                }
            }
        }
    }
    
    private func setButtonState() {
        if let indexSelected = self.boxes.firstIndex(where: { $0.isChecked }) {
            if indexSelected == self.options.count - 1 {
                if let text = self.otherNotes.text, text.count > 0 && text != " " {
                    self.submitButton.set(type: .filled(custom: nil), title: "Kirim Alasan Batalkan Panggilan", titlePosition: nil, font: .font(size: 16, fontType: .bold), icon: nil, iconPosition: nil)
                } else {
                    submitButton.set(type: .disabled, title: "Kirim Alasan Batalkan Panggilan", titlePosition: nil, font: .font(size: 16, fontType: .bold), icon: nil, iconPosition: nil)
                }
            } else {
                self.submitButton.set(type: .filled(custom: nil), title: "Kirim Alasan Batalkan Panggilan", titlePosition: nil, font: .font(size: 16, fontType: .bold), icon: nil, iconPosition: nil)
            }
        } else {
            submitButton.set(type: .disabled, title: "Kirim Alasan Batalkan Panggilan", titlePosition: nil, font: .font(size: 16, fontType: .bold), icon: nil, iconPosition: nil)
        }
    }
    
    private func setupTextview() {
        self.otherNotes.layer.borderColor = UIColor.alteaDark3.cgColor
        self.otherNotes.layer.cornerRadius = 3
        self.otherNotes.layer.borderWidth = 1
        self.otherNotes.delegate = self
        self.setTextviewState()
    }
    
    private func setTextviewState() {
        if let indexSelected = self.boxes.firstIndex(where: { $0.isChecked }) {
            if indexSelected == self.options.count - 1 {
                self.otherNotes.isHidden = false
                self.otherNotes.becomeFirstResponder()
                self.textviewHeightConstraint.constant = 60
                self.containerHeightConstraint.constant = 330
                
                return
            }
        }
        
        self.otherNotes.isHidden = true
        self.otherNotes.resignFirstResponder()
        self.textviewHeightConstraint.constant = 0
        self.containerHeightConstraint.constant = 250
    }

}

extension CallCancelReasonModal: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        self.setButtonState()
    }
}
