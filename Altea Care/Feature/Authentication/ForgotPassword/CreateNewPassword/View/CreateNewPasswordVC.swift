//
//  CreateNewPasswordVC.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 15/03/21.
//

import UIKit
import RxSwift
import RxCocoa

class CreateNewPasswordVC: UIViewController, CreateNewPasswordView {
    
    var onCreatePasswordSuccedd: (() -> Void)?
    var viewModel: CreateNewPasswordVM!
    
    //MARK: - IBOutlet
    @IBOutlet weak var labelMessage: UILabel!
    @IBOutlet weak var labelPageTitle: UILabel!
    @IBOutlet weak var labelCreateNewPassword: UILabel!
    @IBOutlet weak var tfNewPassword: UITextField!
    
    @IBOutlet weak var imageCheckChar: UIImageView!
    @IBOutlet weak var imageCheckCapital: UIImageView!
    @IBOutlet weak var imageCheckNumber: UIImageView!
    @IBOutlet weak var imageCheckSmallChar: UIImageView!
    
    @IBOutlet weak var labelCheckChar: UILabel!
    @IBOutlet weak var labelCheckCapital: UILabel!
    @IBOutlet weak var labelCheckNumber: UILabel!
    @IBOutlet weak var labelCheckSmallChar: UILabel!
    
    @IBOutlet weak var labelConfirmPassword: UILabel!
    @IBOutlet weak var tfConfirmPassword: UITextField!
    @IBOutlet weak var imageWarnNotMatch: UIImageView!
    @IBOutlet weak var labelNotMatch: UILabel!
    
    @IBOutlet weak var buttonSubmit: UIButton!
    ///StackView auto resize
    @IBOutlet weak var stackViewChar: UIStackView!
    @IBOutlet weak var stackViewCapital: UIStackView!
    @IBOutlet weak var stackViewNumber: UIStackView!
    @IBOutlet weak var stackViewSmallChar: UIStackView!
    @IBOutlet weak var containerConfirmPassword: UIView!
    
    
    private let disposeBag = DisposeBag()
    private let requestChangePassword = BehaviorRelay<ChangePasswordBody?>(value: nil)
    
    //MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModel()
        
        setupActiveButton(button: buttonSubmit)
        self.setupNavigation()
        self.setupInitUI()
    }
    
    func bindViewModel() {
        let input = CreateNewPasswordVM.Input(createNewPasswordInput: self.requestChangePassword.asObservable())
        let output =  viewModel.transform(input)
        buttonSubmit.rx.tap.do(onNext: { [unowned self] in
            self.tfNewPassword.resignFirstResponder()
            self.tfConfirmPassword.resignFirstResponder()
        }).subscribe(onNext: { [unowned self] in
            self.requestChangePassword.accept(ChangePasswordBody(password: tfNewPassword.text!, password_confirmation: tfConfirmPassword.text!))
        }, onError: { (error) in
           
        }).disposed(by: self.disposeBag)
        
        output.state.drive(self.rx.state).disposed(by: self.disposeBag)
        output.createNewPasswordOutput.drive { (data) in
            if data?.status == true{
                self.onCreatePasswordSuccedd?()
                Preference.removeString(forKey: .AccessTokenKey)
            }
        }.disposed(by: self.disposeBag)
    }
    
    //MARK: Validation New Password
    @IBAction func validNewPassword(_ sender: Any) {
        let password = tfNewPassword.text ?? ""
        self.validationPasswordShowStackView()
        
        if tfNewPassword.hasText{
            self.validationPassword(password: password)
        } else {
            self.setupInitUI()
        }
    }
    
    func validationPassword(password : String){
        if password.isSmallChar(){
            labelCheckSmallChar.textColor = .black
            imageCheckSmallChar.tintColor = UIColor.alteaMainColor
            imageCheckSmallChar.image = #imageLiteral(resourceName: "Checklist")
        } else {
            labelCheckSmallChar.textColor =  UIColor.red
            imageCheckSmallChar.image = #imageLiteral(resourceName: "exclamationIcon")
        }
        if password.isCapitalChar(){
            labelCheckCapital.textColor = .black
            imageCheckCapital.tintColor = UIColor.alteaMainColor
            imageCheckCapital.image = #imageLiteral(resourceName: "Checklist")
        } else {
            imageCheckCapital.image = #imageLiteral(resourceName: "exclamationIcon")
            labelCheckCapital.textColor = UIColor.red
        }
        if password.isMinimalChar(){
            labelCheckChar.textColor = .black
            imageCheckChar.tintColor = UIColor.alteaMainColor
            imageCheckChar.image = #imageLiteral(resourceName: "Checklist")
        } else {
            imageCheckChar.image = #imageLiteral(resourceName: "exclamationIcon")
            labelCheckChar.textColor = UIColor.red
        }
        
        if password.isNumberInside(){
            labelCheckNumber.textColor = .black
            imageCheckNumber.tintColor = UIColor.alteaMainColor
            imageCheckNumber.image = #imageLiteral(resourceName: "Checklist")
        } else{
            imageCheckNumber.image = #imageLiteral(resourceName: "exclamationIcon")
            labelCheckNumber.textColor = UIColor.red
        }
    }
    
    //MARK: - Validation Confirmation Password
    @IBAction func isValidConfirmPassword(_ sender: Any) {
        let password =  tfNewPassword.text ?? ""
        let confirmPassword = tfConfirmPassword.text ?? ""
        imageWarnNotMatch.isHidden = false
        labelNotMatch.isHidden = false
        
        if password == confirmPassword {
            imageWarnNotMatch.isHidden = true
            labelNotMatch.isHidden = true
            buttonSubmit.isEnabled = true
            buttonSubmit.backgroundColor = UIColor.alteaMainColor
        } else {
            buttonSubmit.isEnabled = false
            buttonSubmit.backgroundColor = UIColor.gray
        }
    }
    
    //MARK: - Setup UI 
    func setupInitUI(){
        self.containerConfirmPassword.isHidden = false
        self.stackViewChar.isHidden = true
        self.stackViewCapital.isHidden = true
        self.stackViewNumber.isHidden = true
        self.stackViewSmallChar.isHidden = true
    }
    
    func validationPasswordShowStackView(){
        self.stackViewChar.isHidden = false
        self.stackViewCapital.isHidden = false
        self.stackViewNumber.isHidden = false
        self.stackViewSmallChar.isHidden = false
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
