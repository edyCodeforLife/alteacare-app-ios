//
//  VerifyPhoneNumberVC.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 10/05/21.
//

import UIKit
import RxSwift
import RxCocoa

class VerifyPhoneNumberVC: UIViewController, VerifyPhoneNumberView {
    var viewModel: VerifyPhoneNumberVM!
    
    var onVerifyPhoneNumberSuccedd: (() -> Void)?
    
    var onChangePhoneNumber: (() -> Void)?
    var phoneNumber: String!
    var oldPhoneNumber: String!
    
    @IBOutlet weak var labelMessage: UILabel!
    @IBOutlet weak var tfOtpPhoneNumber: UITextField!
    @IBOutlet weak var labelWarning: UILabel!
    @IBOutlet weak var iconExclamation: UIImageView!
    @IBOutlet weak var labelCounterTime: UILabel!
    @IBOutlet weak var labelResend: UILabel!
    
    var timer : Timer?
    var totalTime = 0
    
    var status = 0
    
    private let disposeBag = DisposeBag()
    private let requestChangePhoneNumber = BehaviorRelay<ChangePhoneNumberBody?>(value: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModel()
        self.setupNavigation()
        self.setupHideKeyboardWhenTappedAround()
        self.setupInitUI()
        self.setupLabel()
        self.startTimer()
    }
    
    func bindViewModel() {
        let input = VerifyPhoneNumberVM.Input(changePhoneNumberInput: requestChangePhoneNumber.asObservable())
        let output = viewModel.transform(input)
        output.state.drive(self.rx.state).disposed(by: self.disposeBag)
        output.changePhoneNumberOutput.drive { (data) in
            if data?.status == true {
                self.stopTimer()
                self.onVerifyPhoneNumberSuccedd?()
            }
        }.disposed(by: self.disposeBag)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.stopTimer()
    }
    
    @IBAction func otpSended(_ sender: Any) {
        if tfOtpPhoneNumber.text?.count == 6 {
            guard let otp = tfOtpPhoneNumber.text else { return }
            self.requestChangePhoneNumber.accept(ChangePhoneNumberBody(phone: phoneNumber, otp: otp))
            status = 1
        } else {
            status = 0
        }
    }
    
    func setupInitUI(){
        labelResend.isHidden = true
        labelCounterTime.text = "00:00"
    }
    
    private func startTimer(){
        self.totalTime = 120
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
//        self.containerView.isHidden = false
    }
    
    private func stopTimer(){
        self.timer?.invalidate()
    }
    
    @objc func updateTimer(){
        self.labelCounterTime.text = self.timeFormatted(self.totalTime)
        
        if totalTime != 0 {
            totalTime -= 1
        } else {
            labelCounterTime.isHidden = true
            self.setupResendCode()
            if let timer = self.timer{
                self.stopTimer()
                self.timer = nil
            }
        }
    }
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func viewOtpSuccess(){
        self.iconExclamation.image = #imageLiteral(resourceName: "rounded-success-icon")
        self.labelMessage.text = "Verifikasi Berhasil"
    }
    
    func setupResendCode(){
        labelResend.isHidden = false
        let resendCodeText = "Tidak menerima sms ? Kirim Ulang"
        
        labelResend.text = resendCodeText
        
        self.labelResend.textColor = UIColor.black
        
        let boldAttributeString = NSMutableAttributedString(string: resendCodeText)
        let rangeResend = (resendCodeText as NSString).range(of: "Kirim Ulang")
        
        boldAttributeString.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 14), range: rangeResend)
        boldAttributeString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.alteaMainColor, range: rangeResend)
        
        labelResend.attributedText = boldAttributeString
        labelResend.isUserInteractionEnabled = true
        labelResend.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(resendTapped(gesture:))))
    }
    
    @objc func resendTapped(gesture : UITapGestureRecognizer){
        let rangeResend = (labelResend.text! as NSString).range(of: "Kirim Ulang")
        
        if gesture.didTapAttributedTextInLabel(label: labelResend, inRange: rangeResend){
            startTimer()
            labelResend.isHidden = false
            labelResend.isHidden = true
        } else {
            
        }
    }
    
    @IBAction func changePhoneNumberTapped(_ sender: Any) {
        self.onChangePhoneNumber?()
    }
    
    func setupLabel(){
        labelMessage.text = "Kode verifikasi telah dikirim via SMS ke +62\(phoneNumber ?? "")"
    }
    
    private func setupNavigation(){
        self.setTextNavigation(title: "Verifikasi Ubah Nomor Kontak", navigator: .back)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layer.masksToBounds = false
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.lightGray.cgColor
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.8
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 2
    }
}
