//
//  ChangePasswordVC.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 16/03/21.
//

import UIKit
import RxSwift
import RxCocoa

class ChangePasswordVC: UIViewController, ChangePasswordView{
    
    var viewModel: ChangePasswordVM!
    var onChangePasswordSuccedd: (() -> Void)?
    
    @IBOutlet weak var labelChangePassword: UILabel!
    @IBOutlet weak var labelInformChangePassword: UILabel!
    @IBOutlet weak var labelNewPassword: UILabel!
    @IBOutlet weak var tfNewPassword: UITextField!
    
    @IBOutlet weak var imageWarnChar: UIImageView!
    @IBOutlet weak var imageWarnCapital: UIImageView!
    @IBOutlet weak var imageWarnNumber: UIImageView!
    @IBOutlet weak var imageSmallChar: UIImageView!
    
    @IBOutlet weak var labelWarnChar: UILabel!
    @IBOutlet weak var labelWarnCapital: UILabel!
    @IBOutlet weak var labelWarnNumber: UILabel!
    @IBOutlet weak var labelWarnSmallCHar: UILabel!
    
    @IBOutlet weak var tfConfirmPassword: UITextField!
    @IBOutlet weak var labelConfirmChangePassword: UILabel!
    @IBOutlet weak var labelPasswordNotMatch: UILabel!
    @IBOutlet weak var imageWarnNotMatch: UIImageView!
    
    @IBOutlet weak var containerConfirmPassword: UIView!
    @IBOutlet weak var buttonCreateNewPassword: UIButton!
    
    @IBOutlet weak var stackViewChar: UIStackView!
    @IBOutlet weak var stackViewCapital: UIStackView!
    @IBOutlet weak var stackViewNumber: UIStackView!
    @IBOutlet weak var stackViewSmallChar: UIStackView!
    
    private let disposeBag = DisposeBag()
    private let requestChangePassword = BehaviorRelay<ChangePasswordBody?>(value: nil)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModel()
        
        self.setupActiveButton(button: buttonCreateNewPassword)
        self.setupNavigation()
        self.setupInitUI()
        self.requestChangePassword.accept(.none)
    }
    
    func bindViewModel() {
        let input = ChangePasswordVM.Input(changePasswordInput: requestChangePassword.asObservable())
        let output = viewModel.transform(input)
        
        buttonCreateNewPassword.rx.tap.do(onNext: {
            self.tfNewPassword.resignFirstResponder()
            self.tfConfirmPassword.resignFirstResponder()
        }).subscribe(onNext: { [unowned self] in
            self.requestChangePassword.accept(ChangePasswordBody(password: tfNewPassword.text!, password_confirmation: tfConfirmPassword.text!))
        }, onError: { _ in
            
        }).disposed(by: self.disposeBag)
        
        output.state.drive(self.rx.state).disposed(by: self.disposeBag)
        output.changePasswordOutput.drive { (changePassword) in
            if changePassword?.status == true{
                self.onChangePasswordSuccedd?()
            }
        }.disposed(by: self.disposeBag)
    }
    
    func setupInitUI(){
        self.containerConfirmPassword.isHidden = false
        self.stackViewChar.isHidden = true
        self.stackViewCapital.isHidden = true
        self.stackViewNumber.isHidden = true
        self.stackViewSmallChar.isHidden = true
    }
    
    func setupValidationShowStackView(){
        self.stackViewChar.isHidden = false
        self.stackViewCapital.isHidden = false
        self.stackViewNumber.isHidden = false
        self.stackViewSmallChar.isHidden = false
    }
    
    @IBAction func buttonSubmitTapped(_ sender: Any) {
        
    }
    
    func validationPassword(password : String){
        if password.isSmallChar(){
            imageSmallChar.image = #imageLiteral(resourceName: "Checklist")
            imageSmallChar.tintColor = UIColor.blue
            labelWarnSmallCHar.textColor = UIColor.black
        } else {
            imageSmallChar.image = #imageLiteral(resourceName: "exclamationIcon")
            labelWarnSmallCHar.textColor = UIColor.red
        }
        
        if password.isCapitalChar(){
            imageWarnCapital.image = #imageLiteral(resourceName: "Checklist")
            imageWarnCapital.tintColor = UIColor.blue
            labelWarnCapital.textColor = UIColor.black
        } else {
            imageWarnCapital.image = #imageLiteral(resourceName: "exclamationIcon")
            labelWarnCapital.textColor = UIColor.red
        }
        
        if password.isMinimalChar(){
            imageWarnChar.image = #imageLiteral(resourceName: "Checklist")
            imageWarnChar.tintColor = UIColor.blue
            labelWarnChar.textColor = UIColor.black
        } else {
            imageWarnChar.image = #imageLiteral(resourceName: "exclamationIcon")
            labelWarnChar.textColor = UIColor.red
        }
        if password.isNumberInside(){
            imageWarnNumber.image = #imageLiteral(resourceName: "Checklist")
            imageWarnNumber.tintColor = UIColor.blue
            labelWarnNumber.textColor = UIColor.black
        } else {
            imageWarnNumber.image = #imageLiteral(resourceName: "exclamationIcon")
            labelWarnNumber.textColor = UIColor.red
        }
    }
    
    @IBAction func isValidChangedPassword(_ sender: Any) {
        let passowrd = tfNewPassword.text ?? ""
        self.setupValidationShowStackView()
        
        if tfNewPassword.hasText{
            self.validationPassword(password: passowrd)
        } else {
            self.setupInitUI()
        }
    }
    
    @IBAction func isValidConfirmPassword(_ sender: Any) {
        let password = tfNewPassword.text ?? ""
        let confirmPassword =  tfConfirmPassword.text ?? ""
        
        imageWarnNotMatch.isHidden = false
        labelPasswordNotMatch.isHidden = false
        
        if password == confirmPassword{
            imageWarnNotMatch.isHidden = true
            labelPasswordNotMatch.isHidden = true
            buttonCreateNewPassword.isEnabled = true
        } else {
            imageWarnNotMatch.isHidden = false
            labelPasswordNotMatch.isHidden = false
            buttonCreateNewPassword.isEnabled = false
        }
    }
    
    func setupNavigation(){
        self.setTextNavigation(title: "Ubah Kata Sandi", navigator: .back)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layer.masksToBounds = false
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.lightGray.cgColor
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.8
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 2
    }
}
