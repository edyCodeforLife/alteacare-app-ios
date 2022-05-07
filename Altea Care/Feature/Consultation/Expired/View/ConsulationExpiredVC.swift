//
//  ConsulationExpiredVC.swift
//  Altea Care
//
//  Created by Hedy on 17/03/21.
//

import UIKit
import Kingfisher
import RxSwift
import RxCocoa

class ConsulationExpiredVC: UIViewController, ConsulationExpiredView {
    @IBOutlet weak var orderId: ACLabel!
    @IBOutlet weak var doctorCard: DoctorCard!
    @IBOutlet weak var dateTimeBar: DateTimeBar!
    @IBOutlet weak var info: ACLabel!
    @IBOutlet weak var button: ACButton!
    @IBOutlet weak var tncLabel: ACLabel!
    
    private let disposeBag = DisposeBag()
    private let viewDidLoadRelay = PublishRelay<Void>()
    private let requestDetailAppointmentRelay = BehaviorRelay<DetailAppointmentBody?>(value: nil)
    var onPaymentReviewed: (() -> Void)? 
    var model: CancelConsultationModel?{
        didSet{
            
        }
    }
    var idAppointment: Int!
    var viewModel: ConsultationExpiredVM!
    var isRoot: Bool = false
    var onClosed: (() -> Void)?
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.requestDetailAppointmentRelay.accept(DetailAppointmentBody(appointment_id: idAppointment))
        self.viewDidLoadRelay.accept(())
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        setupNavigation()
        setupInitialPage()
    }
    
    func bindViewModel() {
        let input = ConsultationExpiredVM.Input(viewDidLoadRelay: viewDidLoadRelay.asObservable(), detailAppointmentRelay: requestDetailAppointmentRelay.asObservable())
        let output = viewModel.transform(input)
        output.state.drive(self.rx.state).disposed(by: self.disposeBag)
        
        output.appointmentDetailState.drive { [weak self](reviewData) in
            self?.model = reviewData
            self?.setupUI()
            self?.setupCard()
            self?.setupInfo()

        }.disposed(by: self.disposeBag)
    }
    
    private func setupUI() {
        guard let model = model else {return}
        self.orderId.textColor = .alteaDark2
        self.info.textColor = .alteaRedMain
        self.dateTimeBar.leftLabel.textColor = .alteaDark3
        self.dateTimeBar.leftIcon.tintColor = .alteaDark3
        self.dateTimeBar.rightLabel.textColor = .alteaDark3
        self.dateTimeBar.rightIcon.tintColor = .alteaDark3
        self.doctorCard.name.textColor = .alteaDark1
        self.doctorCard.profession.textColor = .alteaDark1
        
        self.button.set(type: .filled(custom: .alteaMainColor), title: "Buat Telekonsultasi Ulang")
        self.tncLabel.textColor = .alteaDark3
        self.info.text = "Maaf, Masa Pembayaran telah berakhir, silahkan buat telekonsultasi ulang untuk telekonsultasi dengan \(model.doctorName)"
        self.tncLabel.text = "*riwayat pembatalan telekonsultasi akan otomatis terhapus setelah 48 Jam."
    }
    
    private func setupNavigation() {
        if isRoot{
            self.setTextNavigation(title: "Dibatalkan", navigator: .close, navigatorCallback: #selector(onCloseAction))
        }else{
            self.setTextNavigation(title: "Dibatalkan", navigator: .back)
        }
    }
    
    @objc private func onCloseAction() {
        self.onClosed?()
    }
    
    private func setupCard() {
        guard let model = model else {return}
        self.orderId.text = "Order ID: \(model.orderCode)"
        if let url = URL(string: model.hospitalIcon) {
            self.doctorCard.hospitalIcon.kf.setImage(with: url)
        }
        if let url = URL(string: model.doctorImage) {
            self.doctorCard.image.kf.setImage(with: url)
        }
        self.doctorCard.hospitalName.text = model.hospitalName
        self.doctorCard.profession.text = model.specialty
        self.doctorCard.name.text = model.doctorName
        self.dateTimeBar.leftLabel.text = model.date?.getIndonesianFullDateString()
        self.dateTimeBar.rightLabel.text = model.time
        doctorCard.isHidden = false
        dateTimeBar.isHidden = false
    }
    
    private func setupInitialPage() {
        title = ""
        doctorCard.isHidden = true
        dateTimeBar.isHidden = true
    }
    
    private func setupInfo() {
        guard let model = model else {return}
        switch model.status {
        case .refund:
            self.info.text = "Pengembalian dana akan diproses maksimal 7 hari kerja"
            self.info.textColor = .info
            self.button.isHidden = true
            self.info.isHidden = false
            self.title = "Refund"
            self.tncLabel.text = "*Hubungi Customer Service untuk informasi proses refund"
        default:
            self.info.text = "Telekonsultasi telah dibatalkan"
            self.button.isHidden = true
            self.info.textColor = .alteaRedMain
            self.info.isHidden = false
            self.title = "Dibatalkan"
            self.tncLabel.text = ""
        }
    }
}
