//
//  VerifyChangeEmailVC.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 26/07/21.
//

import UIKit
import RxSwift
import RxCocoa

class VerifyChangeEmailVC: UIViewController, VerifyChangeEmailView {
    
    var newEmail: String?
    var oldEmail: String?
    var viewModel: VerifyChangeEmailVM!
    var changeEmailVM: ChangeEmailVM!
    var onVerifySuccedd: (() -> Void)?
    
    @IBOutlet weak var sendOtpButton: UIButton!
    @IBOutlet weak var sendOtpView: UIStackView!
    @IBOutlet weak var labelResendCode: UILabel!
    @IBOutlet weak var labelInstruction: UILabel!
    @IBOutlet weak var labelWarningExclamation: UILabel!
    @IBOutlet weak var imageExclamation: UIImageView!
    @IBOutlet weak var labelCounter: UILabel!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var buttonCloseContainer: UIButton!
    @IBOutlet weak var otpTextField: PinCodeTextField!
    private let disposeBag = DisposeBag()
    private let verifyChangeEmailRelay = BehaviorRelay<ChangeEmailVerifyBody?>(value: nil)
    private let changeEmailRelay = BehaviorRelay<RequestChangeEmailBody?>(value: nil)

    var timer : Timer?
    var totalTime = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigation()
        self.bindViewModel()
        self.bindChangeEmailViewModel()
        bindView()
        startTimer()
    }
    
    func bindView() {
        let attrs1 = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor.black]
        let attrs2 = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor.darkGray]
        let attributedString1 = NSMutableAttributedString(string:"Kode verifikasi telah dikirim via \nalamat email ke ", attributes:attrs1)
        let attributedString2 = NSMutableAttributedString(string:newEmail ?? "", attributes:attrs2)
        attributedString1.append(attributedString2)
        labelInstruction.attributedText = attributedString1
        
        buttonCloseContainer.rx.tap.bind{
            self.hideMessageSuccessSendOtp(true)
        }.disposed(by: disposeBag)
        otpTextField.delegate = self
        sendOtpButton.rx.tap.bind{
            guard let newEmail = self.newEmail else{return}
            self.changeEmailRelay.accept(RequestChangeEmailBody(email:newEmail))
        }.disposed(by: disposeBag)
        
    }
    
    func bindViewModel() {
        let input = VerifyChangeEmailVM.Input(verifychangeEmailInput: self.verifyChangeEmailRelay.asObservable())
        let output = viewModel.transform(input)
        output.state.drive(self.rx.state).disposed(by: self.disposeBag)
        output.verifychangeEmailOutput.drive { (model) in
            if model?.status == true {
                                
                guard let oldEmail = self.oldEmail else{return}
                guard let newEmail = self.newEmail else{return}
                CredentialManager.shared.changeEmailUserCredential(newEmail: newEmail, oldEmail: oldEmail)
                self.onVerifySuccedd?()
                
            }
            if model?.status == false {
                self.hideExamation(false)
            }
        }.disposed(by: self.disposeBag)
    }
    
    func bindChangeEmailViewModel(){
        let input = ChangeEmailVM.Input(changeEmailAddressInput: self.changeEmailRelay.asObservable())
        let output = changeEmailVM.transform(input)
        output.state.drive(self.rx.state).disposed(by: self.disposeBag)
        output.changeEmailAddressOutput.drive { (model) in
            if model?.status == true {
                self.startTimer()
                self.hideSendOtpButton(true)
                self.hideExamation(true)
                self.hideMessageSuccessSendOtp(false)
                self.hideCounter(false)
                self.otpTextField.text = ""
            }
        }.disposed(by: self.disposeBag)
    }
    
    private func hideExamation(_ status : Bool){
        labelWarningExclamation.isHidden = status
        imageExclamation.isHidden = status
    }
    
    private func setupNavigation(){
        self.setTextNavigation(title: "Verifikasi Email", navigator: .back)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layer.masksToBounds = false
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.lightGray.cgColor
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.8
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 2
    }
    
    private func startTimer(){
        self.totalTime = 120
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    @objc func updateTimer(){
        self.labelCounter.text = self.timeFormatted(self.totalTime)
        if totalTime != 0 {
            totalTime -= 1
        } else {
            hideCounter(true)
            hideSendOtpButton(false)
            if self.timer != nil{
                self.stopTimer()
                self.timer = nil
            }
        }
    }
    
    private func hideCounter(_ status : Bool){
        labelCounter.isHidden = status
    }
    
    private func hideSendOtpButton(_ status: Bool){
        self.sendOtpView.isHidden = status
    }
    
    private func hideMessageSuccessSendOtp(_ status : Bool){
        messageView.isHidden = status
    }
    
    private func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func stopTimer(){
        self.timer?.invalidate()
    }
}

extension VerifyChangeEmailVC: PinCodeTextFieldDelegate{
    func textFieldDidEndEditing(_ textField: PinCodeTextField){
        guard let otp = textField.text else { return }
        if otp.count  == 6{
            self.verifyChangeEmailRelay.accept(ChangeEmailVerifyBody(email: newEmail ?? "", otp: otp))
        }
    }
}
