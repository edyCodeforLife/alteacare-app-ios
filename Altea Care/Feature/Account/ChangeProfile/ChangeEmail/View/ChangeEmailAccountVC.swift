//
//  ChangeEmailAccountVC.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 21/07/21.
//

import UIKit
import RxSwift
import RxCocoa

class ChangeEmailAccountVC: UIViewController, ChangeEmailAccountView {
    var viewModel: ChangeEmailVM!
    var onVerificationTapped: ((String, String) -> Void)?
    var email: String?

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var tfEmailAddress: UITextField!
    @IBOutlet weak var buttonVerification: UIButton!
    
    @IBAction func verificationButtonTapped(_ sender: UIButton) {
        changeEmailRelay.accept(RequestChangeEmailBody(email: tfEmailAddress.text ?? ""))
    }
    private let disposeBag = DisposeBag()
    private let changeEmailRelay = BehaviorRelay<RequestChangeEmailBody?>(value: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigation()
        self.setupActiveButton(button: buttonVerification)
        self.bindViewModel()
        self.bindView()
        
    }
    
    func bindViewModel(){
        let input = ChangeEmailVM.Input(changeEmailAddressInput: self.changeEmailRelay.asObservable())
        let output = viewModel.transform(input)
        output.state.drive(self.rx.state).disposed(by: self.disposeBag)
        output.changeEmailAddressOutput.drive { (model) in
            if model?.status == true {
                
                self.onVerificationTapped?(self.tfEmailAddress.text ?? "", self.email ?? "" )
            }
        }.disposed(by: self.disposeBag)
    }
    
    func bindView() {
        self.buttonVerification.disableButton()
        tfEmailAddress.rx.text
            .skip(2)
            .subscribe(onNext: { [weak self] (value) in
                guard let self = self else {return}
                guard let text = value else {return}
                if (text.isValidEmail()){
                    self.buttonVerification.enabledButton(color: UIColor.primary)
                }else{
                    self.buttonVerification.disableButton()
                }
            }).disposed(by: self.disposeBag)
    }
    
    private func setupNavigation(){
        self.setTextNavigation(title: "Ubah Alamat Email", navigator: .back)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layer.masksToBounds = false
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.lightGray.cgColor
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.8
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 2
    }
}
