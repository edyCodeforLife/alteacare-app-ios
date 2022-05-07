//
//  InitialSetAccountVC.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 05/04/21.
//

import UIKit
import RxCocoa
import RxSwift

class InitialSetAccountVC: UIViewController, InitialSetAccountView{
    
    var viewModel: InitialSetAccountVM!
    var goToChangePassword: (() -> Void)?
    
    @IBOutlet weak var changePasswordButton: UIButton!
    
    private let disposeBag = DisposeBag()
    
    func bindViewModel() {
        let input = InitialSetAccountVM.Input()
        let output = viewModel.transform(input)
        output.state.drive(self.rx.state).disposed(by: self.disposeBag)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bindViewModel()
        self.setupNavigation()
    }
    
    @IBAction func changeButtonTapped(_ sender: Any) {
        self.goToChangePassword?()
    }
    
    private func setupNavigation(){
        self.setTextNavigation(title: "Pengaturan", navigator: .back)
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.layer.masksToBounds = false
//        self.navigationController?.navigationBar.layer.shadowColor = UIColor.lightGray.cgColor
//        self.navigationController?.navigationBar.layer.shadowOpacity = 0.8
//        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2.0)
//        self.navigationController?.navigationBar.layer.shadowRadius = 2
    }
}
