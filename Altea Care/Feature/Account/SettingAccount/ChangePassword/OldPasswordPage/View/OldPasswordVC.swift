//
//  OldPasswordVC.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 16/03/21.
//

import UIKit
import RxSwift
import RxCocoa

class OldPasswordVC: UIViewController, OldPasswordView{
    
    @IBOutlet weak var labelOldPassword: UILabel!
    @IBOutlet weak var tfOldPassword: UITextField!
    
    @IBOutlet weak var labelWarning: UILabel!
    @IBOutlet weak var imageWarning: UIImageView!
    @IBOutlet weak var buttonCreateNewPassword: UIButton!
    
    var viewModel: OldPasswordVM!
    var oldPasswordSucced: (() -> Void)?
    
    private var model : OldPasswordModel? = nil
    
    private let disposeBag = DisposeBag()
    private let viewDidLoadRelay = PublishRelay<Void?>()
    private let checkOldPassword = BehaviorRelay<CheckOldPasswordBody?>(value: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigation()
        self.bindViewModel()
        self.setupActiveButton(button: buttonCreateNewPassword)
    }
    
    func bindViewModel() {
        let input = OldPasswordVM.Input(checkOldPasswordInput: self.checkOldPassword.asObservable())
        let output =  viewModel.transform(input)
        
        buttonCreateNewPassword.rx.tap.do(onNext: { [weak self] in
            self?.checkOldPassword.accept(CheckOldPasswordBody(password: self?.tfOldPassword.text ?? ""))
        }).subscribe(onNext: {
            
        }, onError: { (error) in
            
        }).disposed(by: self.disposeBag)
        
        
        output.state.drive(self.rx.state).disposed(by: self.disposeBag)
        output.checkOldPasswordOutput.drive { (model) in
            if model?.status == true{
                self.oldPasswordSucced?()
            }
        }.disposed(by: self.disposeBag)
    }
    
    @IBAction func validOldPassword(_ sender: Any) {
        let password =  tfOldPassword.text ?? ""
    }
    
    @IBAction func createNewPassword(_ sender: Any) {
//        self.oldPasswordSucced?()
    }
    
    private func setupNavigation(){
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
