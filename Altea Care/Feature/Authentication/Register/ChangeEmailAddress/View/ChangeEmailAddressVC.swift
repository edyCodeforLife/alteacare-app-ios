//
//  ChangeEmailAddressVC.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 15/03/21.
//

import UIKit
import RxSwift
import RxCocoa

class ChangeEmailAddressVC: UIViewController, ChangeEmailAddressView{
    var state: VerificationType!
    var viewModel: ChangeEmailAddressVM!
    var onChangeEmailAddressSuccedd: (() -> Void)?
    
    @IBOutlet weak var emailSV: UIStackView!
    @IBOutlet weak var phoneSV: UIStackView!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var buttonVerification: UIButton!
    @IBOutlet weak var emailInvalidSV: UIStackView!
    @IBOutlet weak var phoneInvalidSV: UIStackView!
    
    private let disposeBag = DisposeBag()
    private let requestChangeEmailAddress = BehaviorRelay<RegistrationChangeEmailBody?>(value: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModel()
        setupStateView()
        self.setupActiveButton(button: buttonVerification)
        self.setupNavigation()
    }
    
    func bindViewModel() {
        let input = ChangeEmailAddressVM.Input(changeEmailRequest:requestChangeEmailAddress.asObservable())
        let output = viewModel.transform(input)
        output.state.drive(self.rx.state).disposed(by: self.disposeBag)
        output.changeEmailOutput.drive{ (changeEmailData) in
            if((changeEmailData?.status) != nil){
                self.onChangeEmailAddressSuccedd?()
            }
        }.disposed(by:self.disposeBag)
    }
    
    private func setupView(){
        
    }
    
    private func setupNavigation(){
        switch state{
        case .phone:
            self.setTextNavigation(title: "Verifikasi Nomor Ponsel", navigator: .back)
        case .email:
            self.setTextNavigation(title: "Verifikasi Email", navigator: .back)
        default:
            self.setTextNavigation(title: "Verifikasi", navigator: .back)
        }
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layer.masksToBounds = false
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.lightGray.cgColor
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.8
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 2
    }
    
    private func setupStateView(){
        if state == .email{
            phoneSV.isHidden = true
            emailSV.isHidden = false
        }else{
            phoneSV.isHidden = false
            emailSV.isHidden = true
        }
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        if state == .email{
            let emailNew = emailTF.text
            if emailTF.text?.isValidEmail() == true {
                if let email = emailNew{
                    Preference.set(value: email, forKey: .UserEmail)
                    requestChangeEmailAddress.accept(RegistrationChangeEmailBody(email: email))
                }
            }else{
                emailInvalidSV.isHidden = false
            }
        }else {
            let phone = phoneTF.text ?? ""
            
            if phone.isValidPhone() {
                phoneInvalidSV.isHidden = true
                Preference.set(value: phone, forKey: .UserPhone)
                self.onChangeEmailAddressSuccedd?()
            }else{
                phoneInvalidSV.isHidden = false
            }
        }
    }
    
    @IBAction func validEmail(_ sender: Any) {
        let email = emailTF.text ?? ""
        
        if email.isValidEmail() {
            emailInvalidSV.isHidden = true
        }else{
            emailInvalidSV.isHidden = false
        }
    }
    
    @IBAction func validPhone(_ sender: Any) {
        let phone = phoneTF.text ?? ""
        
        if phone.isValidPhone() {
            phoneInvalidSV.isHidden = true
        }else{
            phoneInvalidSV.isHidden = false
        }
    }
    
}
