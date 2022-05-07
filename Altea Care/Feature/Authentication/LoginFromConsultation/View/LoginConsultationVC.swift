//
//  LoginConsultationVC.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 04/05/21.
//

import UIKit
import RxSwift
import RxCocoa

class LoginConsultationVC: UIViewController, LoginConsultationView {
    
    var viewModel: LoginConsultationVM!
    var resgisterationTapped: (() -> Void)?
    var forgotPasswordTapped: (() -> Void)?
    var callCenterTapped: (() -> Void)?
    var nameDoctor: String!
    var photoDoctor: String!
    
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var imageDr: UIImageView!
    @IBOutlet weak var labelDoctorName: UILabel!
    @IBOutlet weak var labelRegister: UILabel!
    @IBOutlet weak var labelInform: UILabel!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var buttonSignup: UIButton!
    @IBOutlet weak var buttonLogin: UIButton!
    @IBOutlet weak var labelNeedHelp: UILabel!
    @IBOutlet weak var buttonCallCenter: UIButton!
    @IBOutlet weak var icwarning: UIImageView!
    @IBOutlet weak var labelMessageEmailNotValid: UILabel!
    @IBOutlet weak var labelMessagePasswordNotValid: UILabel!
    @IBOutlet weak var icWarningPassword: UIImageView!
    
    private let disposeBag = DisposeBag()
    private let viewDidLoadRelay = PublishRelay<Void>()
    private let requestLogin = BehaviorRelay<LoginBody?>(value: nil)
    private let userDataRelay =  BehaviorRelay<String?>(value: nil)
    private var loginBody : LoginBody?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.viewDidLoadRelay.accept(())
        self.setupNavigation()
        self.bindViewModel()
        self.view.setGradientBackground(colorTop: UIColor(hexString: "#ffffff"), colorBottom: UIColor(hexString: "D6EDF6"))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    func bindViewModel() {
        let input = LoginConsultationVM.Input(viewDidLoadRelay: self.viewDidLoadRelay.asObservable(), loginRequest: self.requestLogin.asObservable(), userData: self.userDataRelay.asObservable())
        let output = viewModel.transform(input)
        buttonLogin.rx.tap
                    .do(onNext:  { [unowned self] in
                        self.tfEmail.resignFirstResponder()
                        self.tfPassword.resignFirstResponder()
                    }).subscribe(onNext: { [unowned self] in
                        self.requestLogin.accept(LoginBody(username: tfEmail.text!, password: tfPassword.text!))
                    }, onError: { _ in
                       
                    }).disposed(by: self.disposeBag)

        output.state.drive(self.rx.state).disposed(by: self.disposeBag)
        output.loginOutput.drive { (loginData) in
            if loginData?.status == true {
//                self.viewDidLoadRelay.accept(())
//                self.userDataRelay.accept(.none)
                self.navigationController?.popViewController(animated: true)
                Preference.set(value: loginData?.accessToken, forKey: .AccessTokenKey)
                Preference.set(value: loginData?.refreshToken, forKey: .AccessRefreshTokenKey)
            }
        }.disposed(by: self.disposeBag)
        output.accountData.drive { (userData) in
//            Preference.setStruct(userData, forKey: .User)
            self.navigationController?.popViewController(animated: true)
        }.disposed(by: self.disposeBag)
    }
    
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func setupNavigation(){
        self.setTextNavigation(title: "", navigator: .back)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        self.navigationController!.navigationBar.isTranslucent = true
        self.navigationController!.navigationBar.backgroundColor = UIColor.clear
    }
    
    func setupUI() {
        if (self.photoDoctor.isEmpty) || self.photoDoctor == "-" {
            self.imageDr.image = UIImage(named: "IconAltea")
        } else {
            if let urlPhotoPerson = URL(string: self.photoDoctor ?? ""){
                self.imageDr.kf.setImage(with: urlPhotoPerson)
            }
        }
        
        self.labelDoctorName.text = self.nameDoctor
        
        
    }
    
    @IBAction func actionRegisteration(_ sender: Any) {
//        self.resgisterationTapped?()
    }
    
    @IBAction func actionCallCenter(_ sender: Any) {
//        self.callCenterTapped?()
    }
    
    @IBAction func actionForgotPassword(_ sender: Any) {
//        self.forgotPasswordTapped?()
    }
    
    @IBAction func actionLogin(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func validEmail(_ sender: Any) {
        let username = tfEmail.text ?? ""
        
        self.labelMessageEmailNotValid.isHidden = false
        self.icwarning.isHidden = false
        
        if username.isValidEmail(){
            self.labelMessageEmailNotValid.isHidden = true
            self.icwarning.isHidden = true
        }
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
}
