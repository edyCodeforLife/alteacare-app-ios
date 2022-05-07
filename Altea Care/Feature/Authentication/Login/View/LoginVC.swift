//
//  LoginVC.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import UIKit
import RxSwift
import RxCocoa
import PasswordTextField
import MessageUI

class LoginVC: UIViewController, LoginView {
    
    var onVerifiedAccount: ((VerificationType) -> Void)?
    
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: PasswordTextField!
    @IBOutlet weak var buttonForgotPS: UIButton!
    @IBOutlet weak var labelToRegister: UILabel!
    @IBOutlet weak var labelNeedHelp: UILabel!
    @IBOutlet weak var buttonLogin: UIButton!
    @IBOutlet weak var icWarning: UIImageView!
    @IBOutlet weak var icWarningPassword: UIImageView!
    @IBOutlet weak var labelMessageEmailNotValid: UILabel!
    @IBOutlet weak var labelMessagePasswordNotValid: UILabel!
    
    @IBOutlet weak var buttonAlert: ACButton!
    @IBOutlet weak var buttonClose: UIButton!
    @IBOutlet var parentView: UIView!
    @IBOutlet weak var labelBaru: UILabel!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var doctorName: UILabel!
    @IBOutlet weak var registerAltLabel: UILabel!
    @IBOutlet weak var specialistInfoLabel: UILabel!
    @IBOutlet weak var imageBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var textFieldCenterConstraint: NSLayoutConstraint!
    
    var viewModel: LoginVM!
    var photoDoctor: String?
    var doctor: String?
    var onLoginSucceed: (() -> Void)?
    var onDaftarTapped: (() -> Void)?
    var needHelpTapped: (() -> Void)?
    var forgotKataSandi: (() -> Void)?
    
    private let disposeBag = DisposeBag()
    private let requestLogin = BehaviorRelay<LoginBody?>(value: nil)
    private let requestSendVerificationEmail = BehaviorRelay<SendVerificationEmailBody?>(value: nil)
    private var loginBody : LoginBody?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bindViewModel()
        self.setupLabelRegister()
        self.setupHideKeyboardWhenTappedAround()
        self.setupDeactiveButton(button: buttonLogin)
        self.setupInitial()
        
        self.view.setGradientBackground(colorTop: UIColor(hexString: "#ffffff"), colorBottom: UIColor(hexString: "D6EDF6"))
        self.tfPassword.borderStyle = .none
        self.requestLogin.accept(.none)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.buttonAlert.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func setupInitial(){
        buttonLogin.isEnabled = false
        buttonAlert.onTapped = {
            self.buttonAlert.isHidden = true
        }
        
        let fromSpecialist = self.photoDoctor != nil || self.doctor != nil
        self.doctorName.isHidden = !fromSpecialist
        self.doctorName.text = self.doctor
        self.registerAltLabel.isHidden = !fromSpecialist
        self.labelToRegister.isHidden = fromSpecialist
        self.specialistInfoLabel.isHidden = !fromSpecialist
        self.textFieldCenterConstraint.constant = fromSpecialist ? 0 : -55
        self.imageBottomConstraint.constant = fromSpecialist ? 115 : 0
        if fromSpecialist {
            if let urlString = self.photoDoctor, let url = URL(string: urlString){
                self.logoImage.kf.setImage(with: url)
            }
        } else {
            self.logoImage.image = UIImage(named: "logo-alteacare")
        }
    }
    
    internal func bindViewModel() {
        let input = LoginVM.Input(loginRequest: requestLogin.asObservable(), sendVerificationEmailRequest: requestSendVerificationEmail.asObservable())
        let output = viewModel.transform(input)
        
        buttonLogin.rx.tap
            .do(onNext:  { [unowned self] in
                self.tfEmail.resignFirstResponder()
                self.tfPassword.resignFirstResponder()
            }).subscribe(onNext: { [unowned self] in
                let email = tfEmail.text ?? ""
                let emailLogin = email.trimmingCharacters(in: .whitespaces)
                self.requestLogin.accept(LoginBody(username: emailLogin, password: tfPassword.text!))
            }, onError: { _ in
                print("login Error")
            }).disposed(by: self.disposeBag)
        
        output.state.drive(self.rx.state).disposed(by: self.disposeBag)
        output.loginOutput.drive { (loginData) in
            if loginData?.status == true && loginData?.isVerified == true{
                self.onLoginSucceed?()
                Preference.set(value: loginData?.accessToken, forKey: .AccessTokenKey)
                Preference.set(value: loginData?.refreshToken, forKey: .AccessRefreshTokenKey)
                Preference.set(value: loginData?.deviceID, forKey: .DeviceId)
            }
            if loginData?.status == true && loginData?.isVerified == false {
                self.buttonAlert.isHidden = false
                self.buttonAlert.set(type: .filled(custom: .red), title: "Akun belum terverifikasi")
                                
                
                if (self.tfEmail.text ?? "").isValidEmail(){
                    Preference.set(value: self.tfEmail.text ?? "", forKey: .UserEmail)
                    self.requestSendVerificationEmail.accept(SendVerificationEmailBody(email: self.tfEmail.text ?? "", phone: nil))
                }else if (self.tfEmail.text ?? "").isValidPhone(){
                    Preference.set(value: self.tfEmail.text ?? "", forKey: .UserPhone)
                    self.requestSendVerificationEmail.accept(SendVerificationEmailBody(email: nil, phone: self.tfEmail.text ?? ""))
                }
                
            }
        }.disposed(by: self.disposeBag)
        output.sendVerificationToEmail.drive { (data) in
            if data?.status == true {
                if (self.tfEmail.text ?? "").isValidEmail(){
                    self.onVerifiedAccount?(.email)
                }else if (self.tfEmail.text ?? "").isValidPhone(){
                    self.onVerifiedAccount?(.phone)
                }
                
            }
        }.disposed(by: self.disposeBag)
    }
    
    @IBAction func forgotPasswordButton(_ sender: Any) {
        self.forgotKataSandi?()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    //MARK: - Setup Underline Text for Register and Need Help
    func setupLabelRegister(){
        let text = "Belum Punya Akun? Daftar"
        let textCallHelp = "Butuh bantuan? Hubungi Call Center AlteaCare"
        
        labelToRegister.text = text
        registerAltLabel.text = text
        labelNeedHelp.text = textCallHelp
        
        self.labelNeedHelp.textColor = UIColor.alteaBlueMain
        self.labelToRegister.textColor = UIColor.black
        self.registerAltLabel.textColor = UIColor.black
        
        let underlineAttriString = NSMutableAttributedString(string: text)
        let rangeRegister = (text as NSString).range(of: "Daftar")
        
        let underlineAttributeStringNeedHelp = NSMutableAttributedString(string: textCallHelp)
        let rangeCallTapped = (textCallHelp as NSString).range(of: "Hubungi Call Center AlteaCare")
        
        underlineAttributeStringNeedHelp.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 12), range: rangeCallTapped)
        underlineAttributeStringNeedHelp.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.alteaBlueMain, range: rangeCallTapped)
        
        underlineAttriString.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 12), range: rangeRegister)
        underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.alteaBlueMain, range: rangeRegister)
        
        /// Label Tapped Implemented
        labelNeedHelp.attributedText = underlineAttributeStringNeedHelp
        labelNeedHelp.isUserInteractionEnabled = true
        labelNeedHelp.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapLabelNeedHelp(gesture:))))
        
        labelToRegister.attributedText = underlineAttriString
        labelToRegister.isUserInteractionEnabled = true
        labelToRegister.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapLabel(gesture:))))
        
        registerAltLabel.attributedText = underlineAttriString
        registerAltLabel.isUserInteractionEnabled = true
        registerAltLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAltLabel(gesture:))))
    }
    
    //MARK: - Setup label can be tapped
    @objc func tapLabel(gesture: UITapGestureRecognizer) {
        let textRange = (labelToRegister.text! as NSString).range(of: "Daftar")
        
        if gesture.didTapAttributedTextInLabel(label: labelToRegister, inRange: textRange) {
            self.onDaftarTapped?()
        } else {
          
        }
    }
    
    @objc func tapAltLabel(gesture: UITapGestureRecognizer) {
        let textRange = (registerAltLabel.text! as NSString).range(of: "Daftar")
        
        if gesture.didTapAttributedTextInLabel(label: registerAltLabel, inRange: textRange) {
            self.onDaftarTapped?()
        } else {
          
        }
    }
    
    @IBAction func tapLabelNeedHelp(gesture: UITapGestureRecognizer) {
        let textRange = (labelNeedHelp.text! as NSString).range(of: "Hubungi Call Center AlteaCare")
        
        if gesture.didTapAttributedTextInLabel(label: labelNeedHelp, inRange: textRange) {
            self.needHelpTapped?()
        } else {
      
        }
    }
    
    
    //MARK: - Validasi email and password if empty
    @IBAction func validEmail(_ sender: Any) {
    }
    
    @IBAction func validPassword(_ sender: Any) {
        let password = tfPassword.text ?? ""
        
        self.labelMessagePasswordNotValid.isHidden = false
        self.icWarningPassword.isHidden = false
        
        if password.isValidPassword() {
            buttonLogin.isEnabled = true
            self.setupActiveButton(button: buttonLogin)
            self.labelMessagePasswordNotValid.isHidden = true
            self.icWarningPassword.isHidden = true
        } else {
            buttonLogin.isEnabled = false
            self.setupDeactiveButton(button: buttonLogin)
            self.labelMessagePasswordNotValid.isHidden = false
            self.icWarningPassword.isHidden = false
        }
    }
    
    @IBAction func buttonCloseTapped(_ sender: Any) {
        buttonAlert.isHidden = true
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.onLoginSucceed?()
    }
    
}
