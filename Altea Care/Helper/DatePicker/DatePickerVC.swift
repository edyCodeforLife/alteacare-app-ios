//
//  DatePickerVC.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 14/04/21.
//

import UIKit
import PanModal

protocol DatePickerDelegate: NSObject {
    func dateSelected(date: Date)
}

class DatePickerVC: UIViewController, PanModalPresentable{
    
    var panScrollable: UIScrollView?
    
    weak var delegate : DatePickerDelegate?
    
    @IBOutlet weak var line: ACView!
    @IBOutlet weak var labelSetDate: UILabel!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var buttonSubmit: ACButton!
    
    var datePicker = UIDatePicker()
    var selectedDate = Date()
    
    var isShortFormEnabled = true
    
    var showDragIndicator: Bool{
        return false
    }
    
    var shortFormHeight: PanModalHeight{
        .contentHeight(433.0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupDateView()
        buttonSubmit.set(type: .disabled, title: "Pilih")
        
    }
    
    func setupDateView(){
        datePicker = UIDatePicker.init()
        datePicker.tintColor = UIColor.alteaMainColor
        datePicker.addTarget(self, action: #selector(self.donePressed), for: .valueChanged)
        datePicker.backgroundColor = .white
        datePicker.frame = CGRect(x: 0.0, y: 0.0, width: 280, height: 280)
        
        self.dateView.addSubview(datePicker)
        
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            datePicker.widthAnchor.constraint(equalToConstant: 300),
            datePicker.heightAnchor.constraint(equalToConstant: 300),
            datePicker.centerXAnchor.constraint(equalTo: dateView.centerXAnchor),
            datePicker.centerYAnchor.constraint(equalTo: dateView.centerYAnchor)
        ])
        
        self.setupToolbar()
        
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .inline
        } else {
            datePicker.datePickerMode = .date
        }
        
        buttonSubmit.onTapped = {
            self.dismiss(animated: true, completion: nil)
            self.delegate?.dateSelected(date: self.selectedDate)
        }
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Date().getNextDate()
    }
    
    @objc func donePressed(){
        buttonSubmit.set(type: .filled(custom: UIColor.alteaMainColor), title: "Pilih")
        view.endEditing(true)
        self.selectedDate = datePicker.date
    }
    
    func setupToolbar(){
        let bar = UIToolbar()
        let doneBtn = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissThisKeyboard))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        bar.items = [flexSpace, flexSpace, doneBtn]
        bar.sizeToFit()
    }
}
