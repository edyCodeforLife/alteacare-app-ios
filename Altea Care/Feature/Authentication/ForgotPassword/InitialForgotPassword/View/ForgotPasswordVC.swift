//
//  ForgotPasswordVC.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 15/03/21.
//

import UIKit
import RxSwift
import RxCocoa

class ForgotPasswordVC: UIViewController, ForgotPasswordView{
    
    var viewModel: ForgotPasswordVM!
    var onForgotPasswordSuccedd: ((String) -> Void)?

    @IBOutlet weak var labelForgotPassword: UILabel!
    @IBOutlet weak var labelInstruction: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var phonEmailTF: UITextField!
    @IBOutlet weak var buttonSubmit: UIButton!
    @IBOutlet weak var labelCounterTrying: UILabel!
    
    @IBOutlet weak var containerViewMessage: UIView!
    @IBOutlet weak var labelNote: UILabel!
    @IBOutlet weak var labelMessageNote: UILabel!
    @IBOutlet weak var labelWarning: UILabel!
    @IBOutlet weak var imageWarning: UIImageView!
    
    private let disposeBag = DisposeBag()
    private let requestForgotPassword = BehaviorRelay<RequestForgotPasswordBody?>(value: nil)
    
    var temp = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ///SetupActiveButton
        setupActiveButton(button: buttonSubmit)
        self.bindViewModel()
        self.setupHideKeyboardWhenTappedAround()
        self.setupInitButton()
        self.setupNavigation()
    }
    
    func bindViewModel() {
        let input = ForgotPasswordVM.Input(forgotPasswordInput: self.requestForgotPassword.asObservable())
        let output =  viewModel.transform(input)
        
        output.state.drive(self.rx.state).disposed(by: self.disposeBag)
        output.forgotPasswordOutput.drive { (modelData) in
            if modelData?.status == true {
                self.onForgotPasswordSuccedd?(self.phonEmailTF.text ?? "")
            }
        }.disposed(by: self.disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    //MARK: - Setup Label
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
    
    func setupInitButton(){
        buttonSubmit.isEnabled = false
        buttonSubmit.backgroundColor = UIColor.gray
    }
    
    @IBAction func validateTF(_ sender: Any) {
        let data = phonEmailTF.text ?? ""
        self.imageWarning.isHidden = false
        self.labelWarning.isHidden = false
        
        if data.isValidEmail(){
            buttonSubmit.isEnabled = true
            buttonSubmit.backgroundColor = UIColor.alteaMainColor
            self.imageWarning.isHidden = true
            self.labelWarning.isHidden = true
        }else if data.isValidPhone(){
            buttonSubmit.isEnabled = true
            buttonSubmit.backgroundColor = UIColor.alteaMainColor
            self.imageWarning.isHidden = true
            self.labelWarning.isHidden = true
        }
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        dismissKeyboard()
        self.requestForgotPassword.accept(RequestForgotPasswordBody(username: phonEmailTF.text ?? ""))
    }
}
