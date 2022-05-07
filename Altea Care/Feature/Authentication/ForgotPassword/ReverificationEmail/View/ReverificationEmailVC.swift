//
//  ReverificationEmailVC.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 15/03/21.
//

import UIKit
import RxSwift
import RxCocoa

class ReverificationEmailVC: UIViewController, ReverificationEmailView {
    @IBOutlet weak var labelEmailVerification: UILabel!
    @IBOutlet weak var pinCodeTF: PinCodeTextField!
    @IBOutlet weak var timeCounterLabel: UILabel!
    @IBOutlet weak var resendOTPLabel: UILabel!
    @IBOutlet weak var askLabel: UILabel!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var labelMessageSended: UILabel!
    @IBOutlet weak var buttonClose: UIButton!
    
    
    var viewModel: ReverificationEmailVM!
    var onReverificationEmailSuccedd: (() -> Void)?
    var email: String!
    
    private let disposeBag = DisposeBag()
    private let requestVerifyOtp = BehaviorRelay<VerifyOTPForgotPasswordBody?>(value: nil)
    private let requestNewOtp = BehaviorRelay<RequestForgotPasswordBody?>(value: nil)
    
    var timer : Timer?
    var totalTime = 0
    
    var status = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        setupHideKeyboardWhenTappedAround()
        setupNavigation()
        startOtpTimer()
        setupInitUI()
        setupLabelMessage(email: email)
        containerView.isHidden = false
        pinCodeTF.delegate = self
        pinCodeTF.keyboardType = .numberPad
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
            self.pinCodeTF.becomeFirstResponder()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
//        self.stopTimer()
    }
    
    func bindViewModel() {
        let input = ReverificationEmailVM.Input(verifyOtpInput: self.requestVerifyOtp.asObservable(), requestNewOtpInput: self.requestNewOtp.asObservable())
        let output =  viewModel.transform(input)
        output.state.drive(self.rx.state).disposed(by: self.disposeBag)
        output.verifyOtpOutput.drive { (data) in
            if data?.status == true {
                self.onReverificationEmailSuccedd?()
                self.stopTimer()
                Preference.set(value: data?.data?.accessToken, forKey: .AccessTokenKey)
            }
        }.disposed(by: self.disposeBag)
    }
    
    private func stopTimer(){
        self.timer?.invalidate()
        self.timer = nil
    }
    
    func setupInitUI(){
        resendOTPLabel.isHidden = true
        askLabel.isHidden = true
        timeCounterLabel.text = "00:00"
    }
    
    func shouldBecomeFirstResponderForOTP(otpTextFieldIndex index: Int) -> Bool {
        return false
    }
    
    func enteredOTP(otp: String) {
        print("\(otp)")
    }
    
    func hasEnteredAllOTP(hasEnteredAll: Bool) -> Bool {
        return true
    }
    
    private func startOtpTimer(){
        self.totalTime = 120
        self.containerView.isHidden = false
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        self.containerView.isHidden = true
    }
    
    @objc func updateTimer() {
        self.timeCounterLabel.text = self.timeFormatted(self.totalTime) // will show timer
        if totalTime != 0 {
            totalTime -= 1  // decrease counter timer
        } else {
            self.containerView.isHidden = true
            timeCounterLabel.isHidden = true
            self.setupResendCode()
            
            if self.timer != nil {
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
        resendOTPLabel.isHidden = false
        askLabel.isHidden = false
        
        resendOTPLabel.isUserInteractionEnabled = true
        resendOTPLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(resendTapped(gesture:))))
    }

    func setupLabelMessage(email : String){
        let boldAttributeString = NSMutableAttributedString(string: "Masukkan kode verifikasi telah dikirim ke \(email)")
        let rangeResend = ("Masukkan kode verifikasi telah dikirim ke \(email)" as NSString).range(of: email)
        boldAttributeString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 14), range: rangeResend)
        boldAttributeString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.darkText, range: rangeResend)
        labelEmailVerification.attributedText = boldAttributeString
    }
    
    @objc func resendTapped(gesture : UITapGestureRecognizer){
        let rangeResend = (resendOTPLabel.text! as NSString).range(of: "Kirim Ulang")
        
        if gesture.didTapAttributedTextInLabel(label: resendOTPLabel, inRange: rangeResend){
            self.requestNewOtp.accept(RequestForgotPasswordBody(username: email))
            
            startOtpTimer()
            timeCounterLabel.isHidden = false
            resendOTPLabel.isHidden = true
            askLabel.isHidden = true
            
        } else {
            
        }
    }
    
    private func setupNavigation(){
        self.setTextNavigation(title: "Atur Ulang Kata Sandi", navigator: .back)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layer.masksToBounds = false
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.lightGray.cgColor
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.8
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 2
    }
}
extension ReverificationEmailVC : PinCodeTextFieldDelegate {
    func textFieldDidEndEditing(_ textField: PinCodeTextField){
        guard let otp = textField.text else { return }
        self.requestVerifyOtp.accept(VerifyOTPForgotPasswordBody(username: email, otp: otp))
    }
}
