//
//  ReviewScreeningVC.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class ReviewScreeningVC: UIViewController, ReviewScreeningView {
    
    var viewModel: ReviewScreeningVM!
    var onReviewed: ((String) -> Void)?
    var onCanceled: (() -> Void)?
    var onClosed: (() -> Void)?
    var appointmentId: String!
    var doctor: DoctorCardModel?
    var patientModel: PatientDataModel?
    var endTime: String?
    var timer : Timer?
    
    private let disposeBag = DisposeBag()
    private let fetchRelay = BehaviorRelay<String?>(value: nil)
    
    @IBOutlet weak var titleText: ACLabel!
    @IBOutlet weak var callingTime: ACLabel!
    @IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var textDescription: ACLabel!
    @IBOutlet weak var topButton: ACButton!
    @IBOutlet weak var buttomButton: ACButton!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var labelLastDescription: UILabel!
    @IBOutlet weak var cancelLabel: ACLabel!
    @IBOutlet weak var buttomButtonContraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupData()
        self.bindViewModel()
        self.fetchRelay.accept(self.appointmentId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }

    func bindViewModel() {
        let input = ReviewScreeningVM.Input(fetch: self.fetchRelay.asObservable())
        let output = viewModel.transform(input)
        output.state.drive(self.rx.state).disposed(by: self.disposeBag)
        output.model.drive { (model) in
            guard let model = model else { return }
            self.patientModel = model
            self.doctor = model.doctor
            
            switch model.status {
            case .waitingForPayment:
                self.waitingForPaymentCondition()
                break
            case .gpProcess:
                self.processByGPCondition()
                break
            case .gpCanceled:
                self.canceledByGPCondition()
                break
            default:
                break
            }
        }.disposed(by: self.disposeBag)
        
    }
    
    private func setupUI() {
        self.titleText.font = .font(size: 14, fontType: .bold)
        self.titleText.textColor = .alteaDark2
        self.callingTime.textColor = .alteaBlueMain
        self.imageIcon.layer.cornerRadius = self.imageIcon.frame.height/2
        self.imageIcon.clipsToBounds = true
        self.imageIcon.layer.masksToBounds = false
        self.textDescription.textColor = .alteaBlueMain
        self.cancelLabel.isHidden = true
        self.cancelLabel.textColor = .alteaRedMain
        self.topButton.isHidden = false
        self.topButton.set(type: .filled(custom: .alteaMainColor), title: "Lihat Telekonsultasi Saya")
        self.topButton.layer.cornerRadius = 8
        self.topButton.onTapped = { [weak self] in
            guard let self = self else { return }
            self.onClosed?()
        }
        self.buttomButtonContraint.constant = 20
    }
    
    private func setupData() {
        self.titleText.text = "Panggilan Berakhir"
        self.callingTime.text = self.endTime
        
    }
    
    //MARK: - Button Payment Show but InActive, button go back consultation show
    private func processByGPCondition() {
        self.buttomButton.isHidden = false
        self.textDescription.text = "Rencana telekonsultasi telah terkonfirmasi"
        self.textDescription.textColor = UIColor.alteaBlueMain
        self.setupBoldTextOnLabel(text: "Segera selesaikan pembayaran paling lambat 1 jam sebelum telekonsultasi dimulai", rangeTextBold: "paling lambat 1 jam sebelum telekonsultasi dimulai", label: self.labelDescription)
        self.labelDescription.textColor = UIColor.alteaBlueMain
        self.labelLastDescription.text = "Silakan tunggu, Tautan pembayaran sedang diproses"
        self.labelLastDescription.textColor = UIColor.alteaBlueMain
        self.buttomButton.set(type: .disabled, title: "Pembayaran")
        self.buttomButton.layer.cornerRadius = 8
        self.buttomButton.isUserInteractionEnabled = false
        self.buttomButton.onTapped = { [weak self] in
            guard let self = self else { return }
            self.onReviewed?(self.appointmentId)
        }
    }
    
    //MARK: - Button Go Back List Consultation Active, Button Payment inActive
    private func canceledByGPCondition() {
//        self.doctorCardContainer.isHidden = true
        self.topButton.isHidden = true
        self.buttomButton.isHidden = false
//        self.doctorCardContainerConstraint.constant = 0
        self.cancelLabel.text = "Maaf, telekonsultasi Anda telah dibatalkan"
        self.cancelLabel.isHidden = false
        self.buttomButton.set(type: .filled(custom: .alteaMainColor), title: "Lihat Telekonsultasi Saya")
        self.buttomButton.layer.cornerRadius = 8
        self.buttomButton.onTapped = { [weak self] in
            guard let self = self else { return }
            self.onCanceled?()
        }
        self.buttomButtonContraint.constant = 70
    }
    
    //MARK: - Button Payment Active
    private func waitingForPaymentCondition() {
        self.buttomButton.isHidden = false
        self.labelDescription.textColor = UIColor.alteaBlueMain
        self.setupBoldTextOnLabel(text: "Rencana telekonsultasi telah terkonfirmasi.", rangeTextBold: "", label: labelDescription)
        self.labelLastDescription.textColor = UIColor.alteaBlueMain
        self.setupBoldTextOnLabel(text: "Segera selesaikan pembayaran telekonsultasi paling lambat 1 jam sebelum telekonsultasi dimulai.", rangeTextBold: "paling lambat 1 jam sebelum telekonsultasi dimulai.", label: labelLastDescription)
        self.buttomButton.set(type: .filled(custom: .alteaMainColor), title: "Pembayaran")
        self.buttomButton.isUserInteractionEnabled = true
        self.buttomButton.layer.cornerRadius = 8
        self.buttomButton.onTapped = { [weak self] in
            guard let self = self else { return }
            self.onReviewed?(self.appointmentId)
        }
    }
    
    func setupBoldTextOnLabel(text : String, rangeTextBold : String, label : UILabel){
        label.text = text
        
        let boldAttributedString = NSMutableAttributedString(string: text)
        let rangeBoldString = (text as NSString).range(of: rangeTextBold)
        
        boldAttributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 14), range: rangeBoldString)
        
        label.attributedText = boldAttributedString
    }
}

//MARK: - Setup Tracker
extension ReviewScreeningVC {
    
}
