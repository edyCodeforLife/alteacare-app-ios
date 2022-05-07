//
//  ContactFieldVC.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 12/03/21.
//

import UIKit
import RxSwift
import RxCocoa

class ContactFieldVC: UIViewController, ContactFieldView {
    
    var viewModel: ContactFieldVM!
    var onContactFilledSucced: (() -> Void)?
    var isRoot: Bool!
    var onCloseFromSwitchAcc: (() -> Void)?
    
    @IBOutlet weak var labelIndicatorPage: UILabel!
    @IBOutlet weak var labelIntructionFill: UILabel!
    @IBOutlet weak var labelPhoneNumber: UILabel!
    @IBOutlet weak var tfPhoneNumber: UITextField!
    @IBOutlet weak var imageWarningPhoneNumber
        : UIImageView!
    @IBOutlet weak var labelWarningPhoneNumber
        : UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var imageWarningEmail: UIImageView!
    @IBOutlet weak var buttonSubmit: UIButton!
    @IBOutlet weak var labelWarningEmail: UILabel!
    
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var containerAlertView: UIView!
    @IBOutlet weak var labelAlertMessage: UILabel!
    @IBOutlet weak var buttonClose: UIButton!
    
    var checkEmailModel : CheckEmailRegisterModel? = nil
    
    private let requestCheckEmailInput = BehaviorRelay<CheckEmailRegisterBody?>(value: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupHideKeyboardWhenTappedAround()
        self.bindViewModel()
        self.setupActiveButton(button: buttonSubmit)
        self.setupNavigation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    func bindViewModel() {
        let input = ContactFieldVM.Input(checkEmailRegisterInput: requestCheckEmailInput.asObservable())
        let output = viewModel.transform(input)
        output.state.drive(self.rx.state).disposed(by: self.disposeBag)
        output.checkEmailRegisterOutput.drive { (data) in
            self.checkEmailModel = data
            if self.checkEmailModel?.data.isEmailAvailable == false && self.checkEmailModel?.data.isPhoneAvailable == false{
                self.showCustomAlert()
                self.labelAlertMessage.text = "Email dan nomor telepon sudah digunakan"
            }
            
            if self.checkEmailModel?.data.isEmailAvailable == false && self.checkEmailModel?.data.isPhoneAvailable == true{
                self.showCustomAlert()
                self.labelAlertMessage.text = "Email anda sudah digunakan sebelumnya"
            }
            
            if self.checkEmailModel?.data.isEmailAvailable == true && self.checkEmailModel?.data.isPhoneAvailable == false{
                self.showCustomAlert()
                self.labelAlertMessage.text = "Nomor telepon anda sudah digunakan sebelumnya"
            }
            
            if self.checkEmailModel?.data.isPhoneAvailable == true && self.checkEmailModel?.data.isEmailAvailable == true {
                self.containerAlertView.isHidden = true
                self.onContactFilledSucced?()
            }
        }.disposed(by: self.disposeBag)
        
        tfEmail.rx.text
            .skip(2)
            .subscribe(onNext: { [weak self] (value) in
                guard let self = self else {return}
                if ((value?.isValidEmail()) != nil){
                    Preference.set(value: value, forKey: .UserEmail)
                }
            }).disposed(by: self.disposeBag)
        
        tfPhoneNumber.rx.text
            .skip(2)
            .subscribe(onNext: { [weak self] (value) in
                guard let self = self else {return}
                if ((value?.isValidPhone()) != nil){
                    Preference.set(value: value, forKey: .UserPhone)
                }
                
            }).disposed(by: self.disposeBag)
    }
    
    func showCustomAlert(){
        self.containerAlertView.isHidden = false
    }
    
    @IBAction func buttonCloseTapped(_ sender: Any) {
        self.containerAlertView.isHidden = true
    }
    private func setupNavigation(){
        if isRoot {
            self.setTextNavigation(title: "Daftar", navigator: .close, navigatorCallback: #selector(dismisstapped))
        } else {
            self.setTextNavigation(title: "Daftar", navigator: .back)
        }
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layer.masksToBounds = false
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.lightGray.cgColor
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.8
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 2
    }
    
    @objc func dismisstapped(){
        onCloseFromSwitchAcc?()
    }
    
    @IBAction func validPhoneNumber(_ sender: Any) {
        let phoneNumber = tfPhoneNumber.text ?? ""
        imageWarningPhoneNumber.isHidden = false
        labelWarningPhoneNumber.isHidden = false
        
        if phoneNumber.isValidPhone(){
            imageWarningPhoneNumber.isHidden = true
            labelWarningPhoneNumber.isHidden = true
        }
    }
    
    @IBAction func validEmail(_ sender: Any) {
        let email = tfEmail.text ?? ""
        imageWarningEmail.isHidden = false
        labelWarningEmail.isHidden = false
        
        if email.isValidEmail(){
            imageWarningEmail.isHidden = true
            labelWarningEmail.isHidden = true
        }
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        
        tfEmail.sendActions(for: .editingDidEnd)
        tfPhoneNumber.sendActions(for: .editingDidEnd)
        
        let numberPhone =  tfPhoneNumber.text ?? ""
        let email = tfEmail.text ?? ""
        
        let phoneNumberTrim = numberPhone.trimmingCharacters(in: .whitespaces)
        let emaiTrim = email.trimmingCharacters(in: .whitespaces)
        
        if numberPhone.isEmpty {
            imageWarningPhoneNumber.isHidden = false
            labelWarningPhoneNumber.isHidden = false
        }
        
        if email.isEmpty {
            imageWarningEmail.isHidden = false
            labelWarningEmail.isHidden = false
        }
        
        Preference.set(value: phoneNumberTrim, forKey: .UserPhone)
        Preference.set(value: emaiTrim, forKey: .UserEmail)
        if numberPhone.isEmpty == false && email.isEmpty == false && numberPhone.isValidPhone() && email.isValidEmail(){
            self.requestCheckEmailInput.accept(CheckEmailRegisterBody(email: emaiTrim, phone: phoneNumberTrim))
        }
    }
}
