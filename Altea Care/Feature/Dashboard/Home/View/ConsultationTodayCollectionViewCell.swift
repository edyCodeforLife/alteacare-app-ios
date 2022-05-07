//
//  ConsultationTodayCollectionViewCell.swift
//  Altea Care
//
//  Created by Rahmad Hidayat on 29/06/21.
//

import UIKit
import FSPagerView

class ConsultationTodayCollectionViewCell: FSPagerViewCell{
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var lineTop: UIView!
    @IBOutlet weak var lineBottom: UIView!
    @IBOutlet weak var dateTimeBar: DateTimeBar!
    @IBOutlet weak var btnGo: UIButton!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var orderId: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var hospitalIcon: UIImageView!
    @IBOutlet weak var nameHospital: UILabel!
    @IBOutlet weak var nameDoctor: UILabel!
    @IBOutlet weak var specialization: UILabel!
    @IBOutlet weak var callMAStatusView: UIView!
    @IBOutlet weak var callMALabel: UILabel!
    @IBOutlet weak var statusBackgroundView: UIView!
    
    private var onGoingConsultation: OngoingConsultationModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupUI()
    }
    
    private func setupUI() {
        self.background.layer.cornerRadius = 6
        self.contentView.layer.shadowColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1) //UIColor.alteaDark1.cgColor
        self.contentView.layer.shadowOpacity = 3
        self.contentView.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.contentView.layer.shadowRadius = 2
        
        self.status.layer.masksToBounds = true
        self.status.layer.cornerRadius = 5
        self.dateTimeBar.clipsToBounds = true
        self.lineTop.backgroundColor = .alteaLight3
        self.lineBottom.backgroundColor = .alteaLight3
        
        self.statusBackgroundView.layer.masksToBounds = false
        self.statusBackgroundView.layer.cornerRadius = self.statusBackgroundView.frame.height/4
        
        self.nameHospital.font = UIFont.font(size: 11, fontType: .normal)
        self.nameDoctor.font = UIFont.font(size: 14, fontType: .bold)
        self.specialization.font = UIFont.font(size: 12, fontType: .normal)
    }
    
    func setupGenericUI(model: ConsultationModel) {
        self.orderId.text       = "Order ID: \(model.orderCode) "
        self.status.text        = model.statusDetail
        self.status.textColor   = model.statusTextColor
        self.statusBackgroundView.backgroundColor = model.statusBgColor

        self.nameHospital.text   = model.hospitalName
        self.nameDoctor.text     = model.doctorName
        self.specialization.text = model.specialty
        
        self.dateTimeBar.setupBar(leftLabel: model.dateSchedule?.dateIndonesiaStandard(), rightLabel: model.time, color: .blue)

        if let url = URL(string: model.hospitalIcon) {
            self.hospitalIcon.kf.setImage(with: url)
        }
        if let url = URL(string: model.doctorImage) {
            self.image.kf.setImage(with: url)
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


extension ConsultationTodayCollectionViewCell {
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
