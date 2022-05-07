//
//  RegisterMemberVC.swift
//  Altea Care
//
//  Created by Hedy on 11/08/21.
//

import UIKit
import RxSwift
import RxCocoa

class RegisterMemberVC: UIViewController, RegisterMemberView {
    @IBOutlet weak var successView: UIView!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    
    @IBOutlet weak var phoneContainer : ACView!
    @IBOutlet weak var emailContainer : ACView!
    
    @IBOutlet weak var phoneErrorView : UIView!
    @IBOutlet weak var emailErrorView : UIView!
    
    @IBOutlet weak var phoneErrorLabel : UILabel!
    @IBOutlet weak var emailErrorLabel : UILabel!
    
    @IBOutlet weak var continueButton: ACButton!
    
    var resgistTapped: (() -> Void)?
    var viewModel: RegisterMemberVM!
    var isFromDetail : Bool! = false
    var patientData: AddMemberBody?{
        didSet{
//            addMemberRelay.accept(patientData)
        }
    }
    
    var id: String? {
        didSet{
            idRelay.accept(id)
            if isFromDetail == false{
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.registMemberRequest.accept(RegisterMemberBody(email: self.emailTF.text ?? "", phone: self.phoneTF.text ?? ""))
                }
            }
        }
    }
    
    private let disposeBag = DisposeBag()
    private var phoneValid = BehaviorRelay<Bool>(value: false)
    private var emailValid = BehaviorRelay<Bool>(value: false)
    private let idRelay = BehaviorRelay<String?>(value: nil)
    private let addMemberRelay = BehaviorRelay<AddMemberBody?>(value: nil)
    private let registMemberRequest = BehaviorRelay<RegisterMemberBody?>(value: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        setupRx()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigation()
    }
    
    func bindViewModel() {
        let input = RegisterMemberVM.Input(registMemberRequest: registMemberRequest.asObservable(),
                                           id: idRelay.asObservable(),
                                           addMemberRequest: addMemberRelay.asObservable())
        let output = viewModel.transform(input)
        
        disposeBag.insert([
            output.state.drive(self.rx.state),
            
            output.registMemberOutput.drive { [weak self] (model) in
                self?.showSuccess()
            },
            
            output.addMemberOutput.drive { [weak self] (model) in
                self?.id = model?.id
            },
        ])
    }
    
    private func setupNavigation() {
        self.setTextNavigation(title: "Daftar Akun", navigator: .back)
    }
    
    private func setupUI(){
        continueButton.set(type: .filled(custom: .alteaMainColor), title: "Lanjutkan")
        continueButton.onTapped = { [weak self] in
            guard let self = self else { return }
            self.continueTapped()
        }
    }
    
    private func showSuccess(){
        successView.isHidden = false
        buttonView.isHidden = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.resgistTapped?()
        }
    }
    
    private func setupRx(){
        let someValid = Observable.combineLatest(phoneValid, emailValid) { $0 && $1 }
            .share(replay: 1)
        
        disposeBag.insert([
            phoneTF.rx.text
                .skip(2)
                .subscribe(onNext: { [weak self] (value) in
                    guard let self = self else {return}
                    let _ = self.validationPhone()
                }),
            
            emailTF.rx.text
                .skip(2)
                .subscribe(onNext: { [weak self] (value) in
                    guard let self = self else {return}
                    let _ = self.validationEmail()
                    
                }),
            
            someValid
                .subscribe(onNext: { (value) in
                    if value == true {
                        self.continueButton.set(type: .filled(custom: .alteaMainColor), title: "Lanjutkan")
                    } else {
                        self.continueButton.set(type: .disabled, title: "Lanjutkan")
                    }
                })
        ])
    }
    
    private func validationPhone() -> Bool {
        guard let text = phoneTF.text else { return false }
        
        if text.isEmpty{
            phoneContainer.errorBorder(isError: true)
            phoneErrorLabel.text = "Please fill out this field"
            phoneErrorView.isHidden = false
            phoneValid.accept(false)
            return false
        }
        
        if text.isValidPhone() == false {
            phoneContainer.errorBorder(isError: true)
            phoneErrorLabel.text = "Please fill with valid phone number"
            phoneErrorView.isHidden = false
            phoneValid.accept(false)
            return false
        }
        
        phoneContainer.errorBorder(isError: false)
        phoneErrorLabel.text?.removeAll()
        phoneErrorView.isHidden = true
        phoneValid.accept(true)
        return true
    }
    
    
    private func validationEmail() -> Bool {
        guard let text = emailTF.text else { return false }
        
        if text.isEmpty{
            emailContainer.errorBorder(isError: true)
            emailErrorLabel.text = "Please fill out this field"
            emailErrorView.isHidden = false
            emailValid.accept(false)
            return false
        }
        
        if text.isValidEmail() ==  false{
            emailContainer.errorBorder(isError: true)
            emailErrorLabel.text = "Please fill with valid Email"
            emailErrorView.isHidden = false
            emailValid.accept(false)
            return false
        }
        
        emailContainer.errorBorder(isError: false)
        emailErrorLabel.text?.removeAll()
        emailErrorView.isHidden = true
        emailValid.accept(true)
        return true
    }
    
    // MARK: - BUTTON ACTION
    private func continueTapped(){
        guard validationPhone() && validationEmail() else { return }
        if isFromDetail == true{
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.registMemberRequest.accept(RegisterMemberBody(email: self.emailTF.text ?? "", phone: self.phoneTF.text ?? ""))
            }
        }else {
            guard let data = patientData else {return}
            addMemberRelay.accept(data)
        }
        
    }
    @IBAction func closeTapped(_ sender: Any) {
        resgistTapped?()
    }
}
