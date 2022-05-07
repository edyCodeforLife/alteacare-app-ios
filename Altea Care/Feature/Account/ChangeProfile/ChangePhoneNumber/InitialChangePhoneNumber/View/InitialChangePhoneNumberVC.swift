//
//  InitialChangePhoneNumberVC.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 10/05/21.
//

import UIKit
import RxSwift
import RxCocoa
class InitialChangePhoneNumberVC: UIViewController, InitialChangePhoneNumberView {
    
    var viewModel: InitialChangePhoneNumberVM!
    
    var onVerifyTapped: ((String, String) -> Void)?
    
    var oldPhoneNumber: String!
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelSubTitle: UILabel!
    @IBOutlet weak var tfPhoneNumber: UITextField!
    @IBOutlet weak var buttonVerification: UIButton!
    @IBOutlet weak var exclamation: UIImageView!
    @IBOutlet weak var labelExclamation: UILabel!
    
    private let disposeBag = DisposeBag()
    private let sendPhoneNumberRelay = BehaviorRelay<RequestChangePhoneNumberBody?>(value: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupActiveButton(button: buttonVerification)
        self.setupNavigation()
        self.bindView()
        self.bindViewModel()
    }
    
    private func bindView() {
        buttonVerification.disableButton()
        tfPhoneNumber.rx.text
            .skip(2)
            .subscribe(onNext: { [weak self] (value) in
                guard let self = self else {return}
                guard let text = value?.trimmingCharacters(in: .whitespaces) else {return}
                self.tfPhoneNumber.text = text
                if (text.isValidPhone()){
                    self.buttonVerification.enabledButton(color: UIColor.primary)
                    self.hideExclamation(status: true)
                }else{
                    self.hideExclamation(status: false)
                    self.labelExclamation.text = "Nomor kontak tidak valid"
                    self.buttonVerification.disableButton()
                }
            }).disposed(by: self.disposeBag)
    }
    
    private func hideExclamation(status: Bool){
        self.exclamation.isHidden = status
        self.labelExclamation.isHidden = status
    }
    
    @IBAction func verifikasiChagePhoneNumberTapped(_ sender: Any) {
        
        let phonenumber = tfPhoneNumber.text ?? ""
        if phonenumber.isValidPhone(){
            self.sendPhoneNumberRelay.accept(RequestChangePhoneNumberBody(phone: phonenumber))
        }
    }
    
    func bindViewModel() {
        let input = InitialChangePhoneNumberVM.Input(changePasswordInput: self.sendPhoneNumberRelay.asObservable())
        let output = viewModel.transform(input)
        output.state.drive(self.rx.state).disposed(by: self.disposeBag)
        output.changePhoneNumberOutput.drive { (model) in
            if model?.status == true {
                self.onVerifyTapped?(self.tfPhoneNumber.text ?? "", self.oldPhoneNumber)
            }
        }.disposed(by: self.disposeBag)
    }
    
    private func setupNavigation(){
        self.setTextNavigation(title: "Ubah Nomor Ponsel", navigator: .back)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layer.masksToBounds = false
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.lightGray.cgColor
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.8
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 2
    }
}
