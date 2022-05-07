//
//  OngoingConsultationCell.swift
//  Altea Care
//
//  Created by Hedy on 8/3/21.
//

import UIKit
import Kingfisher

class OngoingConsultationCell: UITableViewCell {
    
    @IBOutlet weak var roleNameLabel: UILabel!
    @IBOutlet weak var orderId: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var doctorCard: DoctorCard!
    @IBOutlet weak var dateTimeBar: DateTimeBar!
    @IBOutlet weak var background: UIView!
    @IBOutlet var lineTop: UIView!
    @IBOutlet weak var lineBottom: UIView!
    @IBOutlet weak var callMAStatusView: UIView!
    @IBOutlet weak var callMALabel: UILabel!
    @IBOutlet weak var statusWidth: NSLayoutConstraint!
    @IBOutlet weak var statusbackgroundView: UIView!
    
    private var onGoingConsultation: OngoingConsultationModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupUI()
    }
    
    private func setupUI() {
        self.selectionStyle = .none
        self.background.layer.cornerRadius = 6
        self.background.layer.shadowColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1) //UIColor.alteaDark1.cgColor
        self.background.layer.shadowOpacity = 3
        self.background.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.background.layer.shadowRadius = 2
        
        self.dateTimeBar.clipsToBounds = true
        self.lineTop.backgroundColor = .alteaLight3
        self.lineBottom.backgroundColor = .alteaLight3
        
        self.statusbackgroundView.layer.masksToBounds = false
        self.statusbackgroundView.layer.cornerRadius = self.statusbackgroundView.frame.height/4
    }
    
    func setupGenericUI(model: ConsultationModel) {
        self.roleNameLabel.text = "\(model.patientFamilyMember?.familyRelationType != nil ? (model.patientFamilyMember?.familyRelationType?.name ?? "") : "Pribadi") - \(model.patientFamilyMember?.name ?? "")"
        
        self.orderId.text       = "Order ID: \(model.orderCode) "
        self.status.text        = model.statusDetail
        self.status.textColor   = model.statusTextColor
        self.statusbackgroundView.backgroundColor = model.statusBgColor

        self.doctorCard.hospitalName.text   = model.hospitalName
        self.doctorCard.name.text           = model.doctorName
        self.doctorCard.profession.text     = model.specialty
        
        self.dateTimeBar.setupBar(leftLabel: model.dateSchedule?.dateIndonesiaStandard(), rightLabel: model.time, color: .blue)
        
        if let url = URL(string: model.hospitalIcon) {
            self.doctorCard.hospitalIcon.kf.setImage(with: url)
        }
        if let url = URL(string: model.doctorImage) {
            self.doctorCard.image.kf.setImage(with: url)
        }
    }
    
    func setupOngoingCosultation(model: OngoingConsultationModel) {
        self.onGoingConsultation = model
        self.setupGenericUI(model: model.generalized())
    }
    
    func setupHistoryCosultation(model: HistoryConsultationModel) {
        self.setupGenericUI(model: model.generalized())
        self.callMAStatusView.isHidden = true
    }
    
    func setupCancelCosultation(model: CancelConsultationModel) {
        self.setupGenericUI(model: model.generalized())
        self.callMAStatusView.isHidden = true
    }
    
    func setupSettingCallMA(setting: SettingModel) {
        guard let consultation = self.onGoingConsultation else {return}
        if (consultation.statusDetail == "Belum terverifikasi" || consultation.statusDetail == "Order baru") {
            if setting.isInOfficeHour(){
                self.callMALabel.text = "Hubungkan ke Medical Advisor"
                self.callMAStatusView.backgroundColor = .primary
                self.setupRoundCorner(view: self.callMAStatusView)
            } else {
                self.callMALabel.text = "Menunggu Jam Operasional MA"
                self.callMAStatusView.backgroundColor = .alteaDark2
                self.setupRoundCorner(view: self.callMAStatusView)
            }
        } else {
            self.callMAStatusView.isHidden = true
        }
    }
}

extension OngoingConsultationCell {
    private func setupRoundCorner (view : UIView) {
        if #available(iOS 11.0, *){
            view.clipsToBounds = true
            view.layer.cornerRadius = 6
            view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        }else{
            let rectShape = CAShapeLayer()
            rectShape.bounds = view.frame
            rectShape.position = view.center
            rectShape.path = UIBezierPath(roundedRect: view.bounds,    byRoundingCorners: [.topRight ,.topRight], cornerRadii: CGSize(width: 6, height: 6)).cgPath
            view.layer.backgroundColor = UIColor.green.cgColor
            view.layer.mask = rectShape
        }
        view.layer.shadowColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        view.layer.shadowOpacity = 3
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 2
        view.isHidden = false
    }
}
