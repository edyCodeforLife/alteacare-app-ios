//
//  RequestCancelVC.swift
//  Altea Care
//
//  Created by Hedy on 28/12/21.
//

import UIKit
import RxSwift
import RxCocoa

class RequestCancelVC: UIViewController, RequestCancelView {
    
    var viewModel: RequestCancelVM!
    var appointmentId: Int!
    var reason: String! {
        didSet {
            self.reasonRelay.accept(self.reason)
        }
    }
    var onCheckConsultation: ((Bool) -> Void)?

    @IBOutlet weak var alertContainerView: UIView!
    @IBOutlet weak var alertLabel: ACLabel!
    @IBOutlet weak var statusSuccessLabel: ACLabel!
    @IBOutlet weak var infoSuccessLabel: ACLabel!
    @IBOutlet weak var checkConsultationButton: ACButton!
    
    private var isSuccess: Bool = false
    
    private let requestRelay = BehaviorRelay<Int?>(value: nil)
    private let reasonRelay = BehaviorRelay<String?>(value: nil)
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModel()
        self.requestRelay.accept(self.appointmentId)
    }
    
    private func setupUI() {
        self.setupAlert()
        self.setupLabelInfo()
        self.setupButton()
    }
    
    private func setupAlert() {
        self.alertContainerView.backgroundColor = isSuccess ? .alteaGreenMain : .alteaRedMain
        self.alertContainerView.isHidden = false
        self.alertLabel.font = .font(size: 14, fontType: .normal)
        self.alertLabel.textColor = .white
        self.alertLabel.text = isSuccess ? "Panggilan Anda berhasil dibatalkan" : "Panggilan Anda gagal dibatalkan"
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            UIView.animate(withDuration: 0.5, animations: {
                self.alertContainerView.alpha = 0
            }) { (finished) in
                self.alertContainerView.isHidden = finished
            }
        }
    }
    
    private func setupLabelInfo() {
        self.statusSuccessLabel.font = .font(size: 15, fontType: .medium)
        self.infoSuccessLabel.font = .font(size: 14, fontType: .normal)
        self.statusSuccessLabel.textColor = isSuccess ? .info : .alteaRedMain
        self.infoSuccessLabel.textColor = .info
        self.statusSuccessLabel.text = isSuccess ? "Panggilan Anda berhasil dibatalkan" : "Panggilan Anda gagal dibatalkan"
        self.infoSuccessLabel.text = "Alasan pembatalan anda telah diterima"
        self.infoSuccessLabel.isHidden = !isSuccess
    }
    
    private func setupButton() {
        checkConsultationButton.isHidden = false
        checkConsultationButton.set(type: .filled(custom: nil), title: "Lihat Telekonsultasi Saya", titlePosition: nil, font: .font(size: 16, fontType: .bold), icon: nil, iconPosition: nil)
        checkConsultationButton.clipsToBounds = true
        checkConsultationButton.onTapped = { [weak self] in
            guard let self = self else { return }
            self.onCheckConsultation?(self.isSuccess)
        }
    }
    
    func bindViewModel() {
        let input = RequestCancelVM.Input(request: self.requestRelay.asObservable(), reason: self.reasonRelay.asObservable())
        let output = viewModel.transform(input)
        output.state.drive(self.rx.state).disposed(by: self.disposeBag)
        output.isSuccess.drive { (isSuccess) in
            guard let isSuccess = isSuccess else { return }
            self.isSuccess = isSuccess
            self.setupUI()
        }.disposed(by: self.disposeBag)
    }

}
