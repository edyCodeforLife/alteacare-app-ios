//
//  ReviewScreeningSpecialist.swift
//  Altea Care
//
//  Created by Admin on 5/4/21.
//

import UIKit
import RxCocoa
import RxSwift

class ReviewScreeningSpecialist: UIViewController, ReviewScreeningSpecialistView {
    
    var viewModel: ReviewScreeningVM!
    var onCheckMedicalResume: (() -> Void)?
    var doctor: DoctorCardModel?
    var patientModel: PatientDataModel?
    var appointmentId: String!
    var endTime: String?
    
    private let disposeBag = DisposeBag()
    private let fetchRelay = BehaviorRelay<String?>(value: nil)
    
    @IBOutlet weak var titleText: ACLabel!
    @IBOutlet weak var callingDuration: ACLabel!
    @IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var firstButtonDesc: ACLabel!
    @IBOutlet weak var medicalResumeButton: ACButton!
    @IBOutlet weak var secondButtonDesc: ACLabel!
    @IBOutlet weak var medicalAdvisorButton: ACButton!
    @IBOutlet weak var orderDrugInfoButton: ACButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupData()
        self.firstCondition()
        self.buttonAction()
        self.bindViewModel()
        self.fetchRelay.accept(self.appointmentId)
    }
    
    private func setupUI() {
        self.titleText.font = .font(size: 14, fontType: .bold)
        self.titleText.textColor = .alteaDark2
        self.callingDuration.textColor = .alteaBlueMain
        self.imageIcon.layer.cornerRadius = self.imageIcon.frame.height/2
        self.imageIcon.clipsToBounds = true
        self.imageIcon.layer.masksToBounds = false
        self.firstButtonDesc.textColor = .alteaBlueMain
        self.secondButtonDesc.textColor = #colorLiteral(red: 0.1725490196, green: 0.3215686275, blue: 0.5450980392, alpha: 1)
    }
    
    private func setupData() {
        self.titleText.text = "Telekonsultasi Berakhir"
        self.callingDuration.text = self.endTime
    }
    
    private func firstCondition() {
        self.firstButtonDesc.text = "kamu dapat melihat resume medis di “konsultasi saya”"
        let attrs1 = [NSAttributedString.Key.font : UIFont.font(), NSAttributedString.Key.foregroundColor : UIColor.info]
        let attrs2 = [NSAttributedString.Key.font : UIFont.font(size: 14, fontType: .bold), NSAttributedString.Key.foregroundColor : UIColor.info]
        let attributedString1 = NSMutableAttributedString(string:"Untuk melihat ringkasan medis, silahkan buka\n", attributes:attrs1)
        let attributedString2 = NSMutableAttributedString(string:"Catatan Dokter", attributes:attrs2)
        attributedString1.append(attributedString2)
        self.firstButtonDesc.attributedText = attributedString1
        
        self.medicalResumeButton.set(type: .filled(custom: nil), title: "Lihat Catatan Dokter", titlePosition: nil, font: .font(size: 16, fontType: .bold), icon: nil, iconPosition: nil)
        self.medicalResumeButton.onTapped = { [weak self] in
            guard let self = self else { return }
            self.onCheckMedicalResume?()
        }
        
//        self.secondButtonDesc.text = "Buat perjanjian telekonsultasi berikutnya:"
//        self.medicalAdvisorButton.set(type: .bordered(custom: .alteaMainColor), title: "Hubungi Medical Advisor")
//        self.medicalAdvisorButton.onTapped = { [weak self] in
//            guard let self = self else { return }
//            ChatManager.shared.show(self, accessToken: <#String#>, identity: "", uniqueRoom: "", roomName: "")
//        }
        
        self.orderDrugInfoButton.set(type: .link(custom: .alteaMainColor), title: "Info Pemesanan Obat", font: .font(size: 16, fontType: .bold))
        
    }
    
    private func buttonAction() {
        self.orderDrugInfoButton.onTapped = {
            let howToOrderVC = HowToOrder()
            howToOrderVC.modalPresentationStyle = .overCurrentContext
            self.present(howToOrderVC, animated: true, completion: nil)
        }
    }
    
    func bindViewModel() {
        let input = ReviewScreeningVM.Input(fetch: self.fetchRelay.asObservable())
        let output = viewModel.transform(input)
        output.state.drive(self.rx.state).disposed(by: self.disposeBag)
        output.model.drive { (model) in
            guard let model = model else { return }
            self.patientModel = model
            self.doctor = model.doctor
            self.firstCondition()
        }.disposed(by: self.disposeBag)
    }

}

//MARK: - Setup Tracker
extension ReviewScreeningSpecialist {
    
}
