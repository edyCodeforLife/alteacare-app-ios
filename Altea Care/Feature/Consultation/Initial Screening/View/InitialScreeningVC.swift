//
//  InitialScreeningVC.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import UIKit
import RxSwift
import RxCocoa

class InitialScreeningVC: UIViewController, InitialScreeningView {
    
    var viewModel: InitialScreeningVM!
    var onInitialSucceed: ((String) -> Void)?
    var onClosed: (() -> Void)?
    var onCancel: ((String) -> Void)?
    private var doctor: DoctorCardModel?
    private var token: ScreeningModel?
    var patientModel: PatientDataModel?
    var appointmentId: Int!
    var orderCode: String?
    var callMA: Bool!
    private var setting: SettingData?
    var timer: Timer?
    var totalTime = 0
    
    private let disposeBag = DisposeBag()
    private let fetchRelay = BehaviorRelay<Int?>(value: nil)
    private let isCallMA = BehaviorRelay<Bool?>(value: nil)
    private let requestCall = PublishRelay<Void>()
    private let requestDisconnect = PublishRelay<Void>()
    private let requestDestroy = PublishRelay<Void>()
    private var isTerminate = false
    private var isFirstConnect = true
    
    @IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var callingText: ACLabel!
    @IBOutlet weak var titleText: ACLabel!
    @IBOutlet weak var doctorName: ACLabel!
    @IBOutlet weak var doctorSpecialty: ACLabel!
    @IBOutlet weak var footerLabel: ACLabel!
    @IBOutlet weak var timerLabel: ACLabel!
    @IBOutlet weak var cancelCallButton: ACButton!
    @IBOutlet weak var infoLabel: ACLabel!
    
    let notifiactionCenter = NotificationCenter.default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.bindViewModel()
        self.fetchRelay.accept(self.appointmentId)
        self.isCallMA.accept(self.callMA)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.notifiactionCenter.addObserver(self, selector: #selector(onResume), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc func onResume(notification:NSNotification) {
        self.fetchRelay.accept(self.appointmentId)
        self.isCallMA.accept(self.callMA)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.notifiactionCenter.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.requestDestroy.accept(())
    }

    func bindViewModel() {
        let input = InitialScreeningVM.Input(fetch: self.fetchRelay.asObservable(), isCallMA: self.isCallMA.asObservable(), requestCall: self.requestCall.asObservable(), requestDisconnect: self.requestDisconnect.asObservable(), requestDestroy: self.requestDestroy.asObservable())
        let output = viewModel.transform(input)
        output.state.drive(self.rx.state).disposed(by: self.disposeBag)
        output.model.drive { model in
            guard let model = model else { return }
            self.doctor = model
            if !self.callMA {
                self.secondCondition(doctorName: self.doctor?.name, speciality: self.doctor?.specialty)
            }
        }.disposed(by: self.disposeBag)
        output.token.drive { (model) in
            guard let model = model else { return }
            self.token = model
            self.cancelCallButton.isHidden = !self.callMA
        }.disposed(by: self.disposeBag)
        output.setting.drive { (setting) in
            guard let setting = setting else { return }
            self.setting = setting
            self.setupTimer(interval: setting.firstDelaySocketConnect)
        }.disposed(by: self.disposeBag)
        output.status.drive { status in
            switch status {
            case .onWaiting:
                print("onWaiting")
            case .onCalled:
                guard let model = self.token else { return }
                self.logMessage(messageText: "on called nih : test")
                VideoCallManager.shared.show(self, accessToken: model.token, identity: model.identity, roomName: model.roomCode, doctor: self.callMA ? nil : self.doctor, appointmentId: self.appointmentId) { (endTime) in
                    self.setupTracker()
                    return self.onInitialSucceed?(endTime)
                }
            case .onError(_):
                self.isTerminate = true
                print("")
            }
        }.disposed(by: self.disposeBag)
    }
    
    private func setupUI() {
        self.imageIcon.makeRounded()
        self.titleText.font = .font(size: 18, fontType: .bold)
        self.titleText.textColor = .alteaBlueMain
        self.imageIcon.image = #imageLiteral(resourceName: "callPlaceholder")
        
        if !self.callMA {
            self.secondCondition(doctorName: self.doctor?.name, speciality: self.doctor?.specialty)
        } else {
            self.titleText.text = "Menghubungkan ke Medical Advisor"
            self.firstCondition()
            self.setupCancelButton()
        }
    }
    
    @objc private func onCloseAction() {
        self.onClosed?()
    }
    
    func logMessage(messageText: String) {
        NSLog(messageText)
    }
    
    private func firstCondition() {
        self.imageIcon.layer.removeAllAnimations()
        
        UIView.animate(withDuration: 0.5) {
            self.doctorName.isHidden = true
            self.doctorSpecialty.isHidden = true
            
            self.timerLabel.isHidden = true
            
            self.callingText.attributedText = nil
            self.callingText.text = "Sesaat lagi Anda akan terhubung dengan layanan Medical Advisor AlteaCare\nMohon Tunggu..."
            self.callingText.textColor = .alteaDark2
            self.callingText.font = .font(size: 12, fontType: .normal)
            
            self.footerLabel.attributedText = nil
            self.footerLabel.text = "Layanan Medical Advisor ini GRATIS."
            self.footerLabel.textColor = .alteaRedMain
            self.footerLabel.font = .font(size: 12, fontType: .medium)
            
            self.infoLabel.isHidden = true
            self.infoLabel.text = ""
            self.infoLabel.textColor = .alteaRedMain
            self.infoLabel.font = .font(size: 12, fontType: .medium)
        }
    }
    
    private func afterCountdownCondition() {
        self.imageIcon.blinked(blinkTime: 60*5)
        
        UIView.animate(withDuration: 0.5) {
            self.doctorName.isHidden = true
            self.doctorSpecialty.isHidden = true
            
            self.timerLabel.isHidden = false
            self.timerLabel.text = "Anda akan terhubung dalam waktu 2-3 menit\nMohon Tunggu..."
            self.timerLabel.textColor = .alteaDark2
            self.timerLabel.font = .font(size: 12, fontType: .normal)
            
            let attrs1 = [NSAttributedString.Key.font : UIFont.font(), NSAttributedString.Key.foregroundColor : UIColor.info]
            let attrs2 = [NSAttributedString.Key.font : UIFont.font(size: 14, fontType: .bold), NSAttributedString.Key.foregroundColor : UIColor.info]
            let attributedString1 = NSMutableAttributedString(string:"Siapkan", attributes:attrs1)
            let attributedString2 = NSMutableAttributedString(string:" KTP ", attributes:attrs2)
            let attributedString3 = NSMutableAttributedString(string:"dan", attributes:attrs1)
            let attributedString4 = NSMutableAttributedString(string:" dokumen penunjang medis ", attributes:attrs2)
            let attributedString5 = NSMutableAttributedString(string:"bila ada yang berhubungan dengan keluhan Anda.", attributes:attrs1)
            attributedString1.append(attributedString2)
            attributedString1.append(attributedString3)
            attributedString1.append(attributedString4)
            attributedString1.append(attributedString5)
            self.callingText.attributedText = attributedString1
            //self.callingText.text = nil
            
            let attrsFooter1 = [NSAttributedString.Key.font : UIFont.font(size: 12, fontType: .normal), NSAttributedString.Key.foregroundColor : UIColor.alteaRedMain]
            let attrsFooter2 = [NSAttributedString.Key.font : UIFont.font(size: 12, fontType: .bold), NSAttributedString.Key.foregroundColor : UIColor.alteaRedMain]
            let attributedStringFooter1 = NSMutableAttributedString(string:"Pastikan", attributes:attrsFooter1)
            let attributedStringFooter2 = NSMutableAttributedString(string:" baterai dan koneksi internet stabil ", attributes:attrsFooter2)
            let attributedStringFooter3 = NSMutableAttributedString(string:"agar telekonsultasi berjalan lancar", attributes:attrsFooter1)
            attributedStringFooter1.append(attributedStringFooter2)
            attributedStringFooter1.append(attributedStringFooter3)
            self.footerLabel.attributedText = attributedStringFooter1
            //self.footerLabel.text = nil
            
            self.infoLabel.isHidden = false
            self.infoLabel.text = "Layanan Medical Advisor ini GRATIS."
            self.infoLabel.textColor = .alteaRedMain
            self.infoLabel.font = .font(size: 12, fontType: .medium)
        }
    }
    
    private func secondCondition(doctorName: String?, speciality: String?) {
        self.imageIcon.blinked(blinkTime: 60*5)
        self.titleText.text = "Menghubungkan ke Spesialis"
        self.doctorName.text = doctorName
        self.doctorSpecialty.text = speciality
        self.imageIcon.image = #imageLiteral(resourceName: "doctorPlaceholder")
        self.callingText.text = "Sedang menghubungkan ke dokter spesialis mohon tunggu sebentar..."
        self.footerLabel.textColor = .alteaDark2
        self.footerLabel.text = "untuk dokumentasi medis, Telekonsultasi ini akan direkam."
    }
    
    private func setupCancelButton() {
        cancelCallButton.set(type: .bordered(custom: UIColor.alteaDark3), title: "Batalkan Panggilan", titlePosition: nil, font: .font(size: 16, fontType: .bold), icon: nil, iconPosition: nil)
        cancelCallButton.clipsToBounds = true
        cancelCallButton.onTapped = { [weak self] in
            guard let self = self else { return }
            self.pauseTimerAndDisconnectSession()
            self.cancelPopup()
        }
    }
    
    private func pauseTimerAndDisconnectSession() {
        self.timer?.invalidate()
        self.timer = nil
        self.requestDisconnect.accept(())
    }
    
    private func setupTimer(interval: Int) {
        let countdown = self.secondsToHoursMinutesSeconds(interval)
        let minutes = countdown.1 < 10 ? "0\(countdown.1)" : "\(countdown.1)"
        let seconds = countdown.2 < 10 ? "0\(countdown.2)" : "\(countdown.2)"
        self.timerLabel.text = "\(minutes):\(seconds)"
        self.timerLabel.textColor = .info
        self.timerLabel.isHidden = false
        self.timerLabel.font = .font(size: 18, fontType: .bold)
        
        if interval < 1 {
            self.requestCallService()
        } else {
            if !self.isFirstConnect {
                self.firstCondition()
            }
            self.timerLabel.isHidden = false
            self.start(countdown: interval)
        }
    }
    
    private func requestCallService() {
        self.afterCountdownCondition()
        self.requestCall.accept(())
        self.isFirstConnect = false
    }
    
    private func secondsToHoursMinutesSeconds(_ seconds: Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    private func start(countdown: Int) {
        self.timer?.invalidate()
        self.totalTime = countdown
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
        
    @objc func updateTimer() {
        self.timerLabel.text = self.timeFormatted(self.totalTime) // will show timer
        if self.totalTime != 0 {
            self.totalTime -= 1  // decrease counter timer
        } else {
            if let timer = self.timer {
                timer.invalidate()
                self.timer = nil
            }
            self.requestCallService()
        }
    }
    
    private func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func cancelPopup() {
        let cancelModal = CallCancelConfirmationModal()
        cancelModal.onConfirmed = { [weak self] (reason) in
            guard let self = self else { return }
            cancelModal.dismiss(animated: true, completion: nil)
            self.requestDisconnect.accept(())
            self.onCancel?(reason)
        }
        cancelModal.onCancel = { [weak self] in
            guard let self = self else { return }
            guard let setting = self.setting else { return }
            self.setupTimer(interval: self.isFirstConnect ? setting.firstDelaySocketConnect : setting.delaySocketConnect)
        }
        presentPanModal(cancelModal)
    }
    
}

//MARK: - Setup Tracker
extension InitialScreeningVC {
    
    func setupTracker() {
        if self.callMA {
            self.track(.callMA(AnalyticsCallMA(appointmentId: "\(self.appointmentId == nil ? "NIL" : "\(self.appointmentId!)")", orderCode: self.orderCode, roomCode: self.token?.roomCode)))
        } else {
            self.track(.callDoctor(AnalyticsCallDoctor(doctorId: doctor?.id, doctorName: doctor?.name, doctorSpecialist: doctor?.specialty, hospitalId: doctor?.hospitalId, hospitalName: doctor?.hospitalName, hospitalArea: nil, diagnosis: patientModel?.diagnosis)))
        }
    }
    
}
