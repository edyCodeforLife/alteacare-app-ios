//
//  GeneralPickerVC.swift
//  Altea Care
//
//  Created by Tiara on 24/08/21.
//

import UIKit
import PanModal
import RxSwift

class GeneralPickerVC: UIViewController, PanModalPresentable {
    @IBOutlet weak var contentUV: UIView!
    @IBOutlet weak var titleL: UILabel!
    @IBOutlet weak var searchUV: ACView!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var selectB: UIButton!
    
    var panScrollable: UIScrollView?
    var chooseHandler: ((Any, Int?) -> Void)?
    
    lazy var pickerTime = UIPickerView()
    lazy var pickerText = UIPickerView()
    lazy var pickerDate = UIDatePicker()
    
    let viewModel = GeneralPickerVM()
    let disposeBag = DisposeBag()
    var titleStr = "Pilih"
    
    var isShortFormEnabled = false
    
    var shortFormHeight: PanModalHeight {
        return .contentHeight(300.0)
    }
    
    var longFormHeight: PanModalHeight {
        return .contentHeight(300.0)
    }
    
    convenience init(title: String, type: PickerType, data: [String] = []) {
        self.init()
        
        self.titleStr = title
        viewModel.type = type
        if !data.isEmpty {
            viewModel.data = data
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        titleL.text = titleStr
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.pickerView
            .subscribe(onNext: { [unowned self] (result) in
                switch result {
                case .reloadPickerText:
                    if self.viewModel.dataSearch.isEmpty {
                        self.selectB.disableButton()
                    } else {
                        self.selectB.enabledButton(color: UIColor.alteaMainColor)
                    }
                    self.pickerText.reloadAllComponents()
                }
            })
            .disposed(by: disposeBag)
        
        switch viewModel.type {
        case .text:
//            searchUV.isHidden = false
            setupPickerText()
        case .date(let mode, let dateDefault):
//            searchUV.isHidden = true
            setupPickerDate(mode, dateDefault: dateDefault)
        case .time:
            searchUV.isHidden = true
            setupPickerTime()
        }
        // Do any additional setup after loading the view.
    }
    
    private func setupPickerDate(_ mode: UIDatePicker.Mode, dateDefault: Date?) {
        pickerDate.frame = contentUV.bounds
        pickerDate.autoresizingMask = [.flexibleWidth]
        contentUV.addSubview(pickerDate)
        
        NSLayoutConstraint.activate([
            pickerDate.widthAnchor.constraint(equalTo: contentUV.widthAnchor),
            pickerDate.topAnchor.constraint(equalTo: contentUV.topAnchor, constant: 0),
            pickerDate.bottomAnchor.constraint(equalTo: contentUV.bottomAnchor, constant: 0),
            pickerDate.leftAnchor.constraint(equalTo: contentUV.leftAnchor, constant: 0),
            pickerDate.rightAnchor.constraint(equalTo: contentUV.rightAnchor, constant: 0),
            pickerDate.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        if let dateDefault = dateDefault {
            pickerDate.setDate(dateDefault, animated: true)
        }
        
        if #available(iOS 14.0, *) {
            pickerDate.preferredDatePickerStyle = .wheels
        }
        
        pickerDate.datePickerMode = mode
        pickerDate.setValue(UIColor.alteaDark1, forKey: "textColor")
        pickerDate.setValue(false, forKeyPath: "highlightsToday")
        
        // Maximum Date is today
        pickerDate.maximumDate = Date()
    }
    
    private func setupPickerTime() {
        pickerTime.frame = contentUV.bounds
        pickerTime.autoresizingMask = [.flexibleWidth]
        contentUV.addSubview(pickerTime)

        pickerTime.delegate = self
        pickerTime.dataSource = self

        let hour = "\(viewModel.time[0])".count == 1 ? "0\(viewModel.time[0])" : "\(viewModel.time[0])"
        let minute = "\(viewModel.time[1])".count == 1 ? "0\(viewModel.time[1])" : "\(viewModel.time[1])"
        let rowHour = viewModel.time[0].firstIndex(of: hour) ?? 0
        let rowMinutes = viewModel.time[1].firstIndex(of: minute) ?? 0
        pickerTime.selectRow(rowHour, inComponent: 0, animated: true)
        pickerTime.selectRow(rowMinutes, inComponent: 1, animated: true)
        setupPickerText()
    }
    
    private func setupPickerText() {
        pickerText.frame = contentUV.bounds
        pickerText.autoresizingMask = [.flexibleWidth]
        contentUV.addSubview(pickerText)
        
        pickerText.delegate = self
        pickerText.dataSource = self
        
        searchTF.rx.text.orEmpty
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] (keyword) in
                self?.viewModel.updateSourcePicker(keyword)
            })
            .disposed(by: disposeBag)
    }

    @IBAction func cancelTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func chooseTapped(_ sender: UIButton) {
        switch viewModel.type {
        case .text:
            let textResult = viewModel.dataSearch[pickerText.selectedRow(inComponent: 0)]
            let rowResult = viewModel.data.firstIndex(of: textResult)
            chooseHandler?(textResult, rowResult)
        case .date(let mode, _):
            switch mode {
            case .countDownTimer:
                chooseHandler?(pickerDate.countDownDuration, nil)
            default:
                chooseHandler?(pickerDate.date, nil)
            }
        case .time:
            let timeResult = "\(viewModel.time[0][pickerTime.selectedRow(inComponent: 0)]):\(viewModel.time[1][pickerTime.selectedRow(inComponent: 1)])"
            chooseHandler?(timeResult, nil)
        }
    }

}

extension GeneralPickerVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView == pickerTime {
            return 2
        } else {
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pickerTime {
            return viewModel.time[component].count
        } else {
            return viewModel.dataSearch.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        if pickerView == pickerTime {
            var pickerLabel: UILabel? = (view as? UILabel)
            if pickerLabel == nil {
                pickerLabel = UILabel()
                pickerLabel?.font = UIFont(name: "Inter-SemiBold", size: 16)
                pickerLabel?.textAlignment = .center
            }
            pickerLabel?.text = viewModel.time[component][row]
            pickerLabel?.textColor = UIColor.alteaDark1

            return pickerLabel!
        } else {
            var pickerLabel: UILabel? = (view as? UILabel)
            if pickerLabel == nil {
                pickerLabel = UILabel()
                pickerLabel?.font = UIFont(name: "Inter-SemiBold", size: 16)
                pickerLabel?.textAlignment = .center
            }
            pickerLabel?.text = viewModel.dataSearch[row]
            pickerLabel?.textColor = UIColor.alteaDark1

            return pickerLabel!
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        if pickerView == pickerTime {
            return 60
        } else {
            return pickerView.frame.size.width
        }
    }
}


struct GeneralPicker {
    static func open(from: UIViewController,title: String, type: PickerType, data: [String], completion: ((Any, Int?) -> Void)?) {
        dismissKeyboard()
        let vc = GeneralPickerVC(title: title, type: type, data: data)
        from.presentPanModal(vc)
        vc.chooseHandler = { result, row in
            DispatchQueue.main.async {
                from.dismiss(animated: true, completion: nil)
                completion?(result, row)
            }
        }
    }
}
