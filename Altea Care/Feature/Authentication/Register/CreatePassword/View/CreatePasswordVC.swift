//
//  CreatePasswordVC.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 12/03/21.
//

import UIKit
import RxSwift
import RxCocoa

class CreatePasswordVC: UIViewController, CreatePasswordView {
    
    var viewModel: CreatePasswordVM!
    var onCreatePasswordSucceed: (() -> Void)?
    private let disposeBag = DisposeBag()
    
    //MARK: - IBOutlet
    @IBOutlet weak var labelIndicator: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelMessage: UILabel!
    @IBOutlet weak var labelPassword: UILabel!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var imageCheckChar: UIImageView!
    @IBOutlet weak var labelCheckChar: UILabel!
    @IBOutlet weak var imageCheckCapital: UIImageView!
    @IBOutlet weak var labelCheckCapital: UILabel!
    @IBOutlet weak var imageCheckNumber: UIImageView!
    @IBOutlet weak var labelCheckNumber: UILabel!
    @IBOutlet weak var imageCheckSmallChar: UIImageView!
    @IBOutlet weak var labelCheckSmallChar: UILabel!
    
    @IBOutlet weak var labelConfirmPassword: UILabel!
    @IBOutlet weak var tfConfirmPassword: UITextField!
    @IBOutlet weak var labelCheckConfirmPS: UILabel!
    @IBOutlet weak var imageCheckConfirmPS: UIImageView!
    
    @IBOutlet weak var buttonCreatePassword: UIButton!
    
    @IBOutlet weak var stackViewMinimalChar: UIStackView!
    @IBOutlet weak var stackViewCapital: UIStackView!
    @IBOutlet weak var stackViewNumber: UIStackView!
    @IBOutlet weak var stackViewSmallChar: UIStackView!
    @IBOutlet weak var containerView: UIView!
    
    
    //MARK: - View Did load
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModel()
        
        self.setupActiveButton(button: buttonCreatePassword)
        self.setupNavigation()
        self.setupInitUI()
    }
    
    func bindViewModel() {
        let input = CreatePasswordVM.Input()
        let output = viewModel.transform(input)
        output.state.drive(self.rx.state).disposed(by: self.disposeBag)
    }
    
    //MARK: - Button next tapped
    ///If confirm password isEmpty false and password isEmpty false
    @IBAction func buttonTapped(_ sender: Any) {
        let password = tfPassword.text ?? ""
        let confirmPassword =  tfConfirmPassword.text ?? ""
        
        UserDefaults.standard.set(password,forKey: "password")
        if confirmPassword.isEmpty {
            labelCheckConfirmPS.isHidden = false
            labelCheckConfirmPS.text = "Konfirmasi kata sandi tidak boleh kosong"
        }
        
        if password.isEmpty {
            labelCheckChar.isHidden = false
            labelCheckChar.text = "Kata sandi tidak boleh kosong"
        }
        
        if password.isEmpty == false && confirmPassword.isEmpty == false && password.isValidPassword()
            {
            self.onCreatePasswordSucceed?()
        }
    }
    
    //MARK: - Validation Password
    @IBAction func validPassword(_ sender: Any) {
        let password = tfPassword.text ?? ""
        self.validationPasswordShowStackView()
        
        if tfPassword.hasText {
            self.validationPassword(password: password)
        } else {
            self.setupInitUI()
        }
    }
    
    func validationPassword(password : String){
        if password.isSmallChar(){
            imageCheckSmallChar.image = #imageLiteral(resourceName: "Checklist")
            imageCheckSmallChar.tintColor = UIColor.blue
            labelCheckSmallChar.textColor = UIColor.black
        } else {
            imageCheckSmallChar.image = #imageLiteral(resourceName: "exclamationIcon")
            labelCheckSmallChar.textColor = UIColor.red
        }
        
        if password.isCapitalChar(){
            imageCheckCapital.image = #imageLiteral(resourceName: "Checklist")
            imageCheckCapital.tintColor = UIColor.blue
            labelCheckCapital.textColor = UIColor.black
        } else {
            imageCheckCapital.image = #imageLiteral(resourceName: "exclamationIcon")
            labelCheckCapital.textColor = UIColor.red
        }
        
        if password.isMinimalChar(){
            imageCheckChar.image = #imageLiteral(resourceName: "Checklist")
            imageCheckChar.tintColor = UIColor.blue
            labelCheckChar.textColor = UIColor.black
        } else {
            imageCheckChar.image = #imageLiteral(resourceName: "exclamationIcon")
            labelCheckChar.textColor = UIColor.red
        }
        if password.isNumberInside(){
            imageCheckNumber.image = #imageLiteral(resourceName: "Checklist")
            imageCheckNumber.tintColor = UIColor.blue
            labelCheckNumber.textColor = UIColor.black
        } else {
            imageCheckNumber.image = #imageLiteral(resourceName: "exclamationIcon")
            labelCheckNumber.textColor = UIColor.red
        }
    }
    
    //MARK: - Validation Confirm Password
    ///Must be same between password and confirm password
    @IBAction func validConfirmPassword(_ sender: Any) {
        tfPassword.sendActions(for: .editingDidEnd)
        tfConfirmPassword.sendActions(for: .editingDidEnd)
        
        let password = tfPassword.text ?? ""
        let confirmPassword = tfConfirmPassword.text ?? ""
        
        UserDefaults.standard.set(confirmPassword, forKey: "confirm_password")
        imageCheckConfirmPS.isHidden = false
        labelCheckConfirmPS.isHidden = false
        
        if password == confirmPassword{
            imageCheckConfirmPS.isHidden = true
            labelCheckConfirmPS.isHidden = true
        }
    }
    
    //MARK: - Setup initial UI for first appear
    private func setupInitUI(){
        self.containerView.isHidden =  false
        self.stackViewMinimalChar.isHidden = true
        self.stackViewCapital.isHidden = true
        self.stackViewNumber.isHidden = true
        self.stackViewSmallChar.isHidden = true
    }
    
    //MARK: - Unhidded Stack View
    func validationPasswordShowStackView(){
        self.stackViewMinimalChar.isHidden = false
        self.stackViewCapital.isHidden = false
        self.stackViewNumber.isHidden = false
        self.stackViewSmallChar.isHidden = false
    }
    
    //MARK: - SetupNavigation
    private func setupNavigation(){
        self.setTextNavigation(title: "Buat Kata Sandi", navigator: .back)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layer.masksToBounds = false
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.lightGray.cgColor
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.8
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 2
    }
}
