//
//  VerificationEmailVC.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 12/03/21.
//

import UIKit
import RxSwift
import RxCocoa

class VerificationEmailVC: UIViewController, EmailVerificationView{
    
    @IBOutlet weak var verificationLabel: UILabel!
    @IBOutlet weak var informLabel: UILabel!
    @IBOutlet weak var labelTimer: UILabel!
    @IBOutlet weak var resendCodeLabel: UILabel!
    
    @IBOutlet weak var codeFalseSV: UIStackView!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var iconExclamation: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var buttonClose: UIButton!
    
    @IBOutlet weak var changeVerificationButton: UIButton!
    @IBOutlet weak var changeDataButton: UIButton!
    @IBOutlet weak var pinCodeTF: PinCodeTextField!
    
    var onChangeEmailAddress: ((VerificationType) -> Void)?
    var viewModel: EmailVerificationVM!
    var onEmailVerificationSuccedd: (() -> Void)?
    var goToRegisterSuccedd: (() -> Void)?
    
    private let requestSendVerificationEmail = BehaviorRelay<SendVerificationEmailBody?>(value: nil)
    private let requestVerifyEmail = BehaviorRelay<VerifyEmailBody?>(value: nil)
    private let type = BehaviorRelay<String>(value: "phone")
    private let disposeBag = DisposeBag()
    
    var timer : Timer?
    var totalTime = 0
    var status = 0
    
    var isFromLogin: Bool!
    var state : VerificationType!{
        didSet{
            type.accept(state == .email ? "email" : "phone")
            if isViewLoaded{
                if state == .email {
                    viewModel.requestNewOTP(body: SendVerificationEmailBody(email: "\(Preference.getString(forKey: .UserEmail) ?? "")", phone: nil))
                }else{
                    viewModel.requestNewOTP(body: SendVerificationEmailBody(email: nil,phone: "\(Preference.getString(forKey: .UserPhone) ?? "")"))
                }
                setupNavigation()
                setupHideKeyboardWhenTappedAround()
                setupInitUI()
                setupLabelMessage()
                startTimer()
                removeLocalData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        setupNavigation()
        setupHideKeyboardWhenTappedAround()
        setupInitUI()
        setupLabelMessage()
        startTimer()
        removeLocalData()
        pinCodeTF.delegate = self
        pinCodeTF.keyboardType = .numberPad
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.pinCodeTF.becomeFirstResponder()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        //        self.stopTimer()
    }
    
    func bindViewModel() {
        let input = EmailVerificationVM.Input(sendVerificationEmailRequest: requestSendVerificationEmail.asObservable(),
                                              sendVerifyEmailRequest: requestVerifyEmail.asObservable(),
                                              type: type.asObservable())
        let output =  viewModel.transform(input)
        output.state.drive(self.rx.state).disposed(by: self.disposeBag)
        output.verifyOTPOutput.drive { (data) in
            if data?.status == true {
                self.codeFalseSV.isHidden = true
//                Preference.removeString(forKey: .UserEmail)
//                Preference.removeString(forKey: .UserPhone)
                if let data = data?.data {
                    HTTPAuth.shared.saveBearer(token: data.accessToken)
                    HTTPAuth.shared.saveRefresh(token: data.refreshToken)
                    self.stopTimer()
                    self.viewOtpSuccess()
                }
            }
            
            if data?.status == false {
                self.codeFalseSV.isHidden = false
            }
        }.disposed(by: self.disposeBag)
    }
    
    func removeLocalData(){
        UserDefaults.standard.removeObject(forKey: "password")
    }
    
    func setupInitUI(){
        resendCodeLabel.isHidden = true
        labelTimer.text = "00:00"
        pinCodeTF.text = ""
        self.codeFalseSV.isHidden = true
        
        changeVerificationButton.isHidden = isFromLogin ? true : false
        if state == .email{
            changeVerificationButton.setTitle("Kirim kode verifikasi via SMS", for: .normal)
            changeDataButton.setTitle("Ubah alamat email", for: .normal)
            verificationLabel.text = "Email verifikasi telah dikirim"
        }else{
            changeVerificationButton.setTitle("Kirim kode verifikasi via email", for: .normal)
            changeDataButton.setTitle("Ubah nomor ponsel", for: .normal)
            verificationLabel.text = "SMS verifikasi telah dikirim"
        }
    }
    
    private func startTimer(){
        self.totalTime = 120
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        self.containerView.isHidden = false
    }
    
    private func stopTimer(){
        self.timer?.invalidate()
    }
    
    @IBAction func buttonCloseTapped(_ sender: Any) {
        self.containerView.isHidden = true
    }
    
    func setupLabelMessage(){
        if state == .phone{
            informLabel.text = "Kode verifikasi telah dikirim via SMS ke \(Preference.getString(forKey: .UserPhone) ?? "")"
        }else{
            informLabel.text = "Kode verifikasi telah dikirim via email ke \(Preference.getString(forKey: .UserEmail) ?? "")"
        }
    }
    
    @objc func updateTimer(){
        self.labelTimer.text = self.timeFormatted(self.totalTime)
        
        if totalTime != 0 {
            totalTime -= 1
        } else {
            labelTimer.isHidden = true
            self.containerView.isHidden = true
            self.setupResendCode()
            //            tfOtp.isEnabled = false
            if self.timer != nil{
                self.stopTimer()
                self.timer = nil
            }
        }
    }
    
    private func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func setupResendCode(){
        resendCodeLabel.isHidden = false
        var resendCodeText = ""
        if state == .email{
            resendCodeText = "Tidak menerima email ? Kirim Ulang"
        }else{
            resendCodeText = "Tidak menerima SMS ? Kirim Ulang"
        }
        
        resendCodeLabel.text = resendCodeText
        
        self.resendCodeLabel.textColor = UIColor.black
        
        let boldAttributeString = NSMutableAttributedString(string: resendCodeText)
        let rangeResend = (resendCodeText as NSString).range(of: "Kirim Ulang")
        
        boldAttributeString.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 14), range: rangeResend)
        boldAttributeString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.alteaMainColor, range: rangeResend)
        
        resendCodeLabel.attributedText = boldAttributeString
        resendCodeLabel.isUserInteractionEnabled = true
        resendCodeLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(resendTapped(gesture:))))
    }
    
    @objc func resendTapped(gesture : UITapGestureRecognizer){
        let rangeResend = (resendCodeLabel.text! as NSString).range(of: "Kirim Ulang")
        
        if gesture.didTapAttributedTextInLabel(label: resendCodeLabel, inRange: rangeResend){
            startTimer()
            labelTimer.isHidden = false
            resendCodeLabel.isHidden = true
            if state == .email {
                viewModel.requestNewOTP(body: SendVerificationEmailBody(email: "\(Preference.getString(forKey: .UserEmail) ?? "")", phone: nil))
            }else{
                viewModel.requestNewOTP(body: SendVerificationEmailBody(email: nil, phone: "\(Preference.getString(forKey: .UserPhone) ?? "")"))
            }
        }
    }
    func viewOtpSuccess(){
        self.containerView.isHidden = false
        self.containerView.backgroundColor = UIColor.alteaMainColor
        self.iconExclamation.image = #imageLiteral(resourceName: "rounded-success-icon")
        self.messageLabel.text = "Verifikasi Berhasil"
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.onEmailVerificationSuccedd?()
        }
    }
    
    @IBAction func changeEmailTapped(_ sender: Any) {
        self.onChangeEmailAddress?(state)
    }
    
    @IBAction func changeState(_ sender: Any) {
        if state == .email{
            state = .phone
            
        }else{
            state = .email
        }
    }
    private func setupNavigation(){
        if state == .email{
            self.setTextNavigation(title: "Verifikasi Email", navigator: .none)
        }else{
            self.setTextNavigation(title: "Verifikasi Nomor Ponsel", navigator: .none)
        }
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layer.masksToBounds = false
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.lightGray.cgColor
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.8
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 2
    }
}

extension VerificationEmailVC : PinCodeTextFieldDelegate {
    func textFieldDidEndEditing(_ textField: PinCodeTextField){
        guard let otp = textField.text else { return }
        if otp.count  == 6{
            if state == .email {
                self.viewModel.requestVerifyEmail(body: VerifyEmailBody(email: Preference.getString(forKey: .UserEmail), otp: otp, phone: nil))
            }else{
                self.viewModel.requestVerifyEmail(body: VerifyEmailBody(email: nil, otp: otp, phone: Preference.getString(forKey: .UserPhone)))
            }
        }
        status = 1
    }
}


enum VerificationType{
    case phone
    case email
}

