//
//  VoucherVC.swift
//  Altea Care
//
//  Created by Tiara on 11/09/21.
//

import UIKit
import RxSwift
import RxCocoa

class VoucherVC: UIViewController, VoucherView {
    @IBOutlet weak var voucherTF: UITextField!
    @IBOutlet weak var applyButton: ACButton!
    @IBOutlet weak var resultLabel: UILabel!
    
    var viewModel: VoucherVM!
    var transactionId: String!
    var voucherOnUsed: ((VoucherModel) -> Void)?
    
    private let viewDidLoadRelay = PublishRelay<Void>()
    private let voucherOutputRelay = BehaviorRelay<VoucherModel?>(value: nil)
    private let voucherKeywordRelay = BehaviorRelay<VoucherBody?>(value: nil)
    private let disposeBag = DisposeBag()
    
    private var model : VoucherModel? = nil {
        didSet {
            guard let state = model?.status else{return}
            setState(isSuccess: state)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupButton()
        bindViewModel()
        viewDidLoadRelay.accept(())
    }
    
    func bindViewModel() {
        let input = VoucherVM.Input(viewDidLoadRelay: viewDidLoadRelay.asObservable(),
                                    voucher: voucherKeywordRelay.asObservable())
        let output = viewModel.transform(input)
        
        disposeBag.insert([
            output.state.drive(self.rx.state),
            
            output.voucherOutput.drive { (data) in
                self.model = data
            },
        ])
    }
    
    func setupNavigation() {
        self.setTextNavigation(title: "Gunakan Voucher", navigator: .close)
    }

    private func setupButton(){
        applyButton.set(type: .filled(custom: nil), title: "Gunakan")
        applyButton.onTapped = { [weak self] in
            guard let self = self else { return }
            self.sendRequest()
        }
    }
    
    private func setState(isSuccess:Bool){
        resultLabel.isHidden  = false
        resultLabel.textColor = isSuccess ? .alteaGreenMain : .alteaRedMain
        resultLabel.text = isSuccess ? "Yeay! Voucher berhasil ditambahkan" : "Oops! Voucher tidak ditemukan"
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if isSuccess {
                guard let data = self.model else{return}
                self.voucherOnUsed?(data)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: VoucherNotificationName), object: nil)
            }
        }
    }
    
    func sendRequest(){
        guard let id = transactionId else{return}
        let request = VoucherBody(code: voucherTF.text ?? "", transaction_id: id, type_of_service: "TELEKONSULTASI")
        voucherKeywordRelay.accept(request)
    }

}
