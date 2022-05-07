//
//  SwitchAccountVC.swift
//  Altea Care
//
//  Created by Tiara on 09/09/21.
//

import UIKit
import RxSwift
import RxCocoa
import PanModal

class SwitchAccountVC: UIViewController, SwitchAccountView {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var button: ACButton!
    
    var onSignInTapped: (() -> Void)?
    var onGoToRegister: (() -> Void)?
    var goToHome: (() -> Void)?
    var dataListAccount: (([UserCredential]))!
    
    private lazy var popAddAccountView : PopAddAccountVC = {
        let vc = PopAddAccountVC()
        vc.delegate = self
        return vc
    }()
    
    private let disposeBag = DisposeBag()
    var viewModel: SwitchAccountVM!
    var userEmail : String?
    let dataAccounts = CredentialManager.shared.getCredentials()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton()
        self.registerTableView()
        
        if #available(iOS 15.0, *) {
            UITableView.appearance().sectionHeaderTopPadding = 0
        }
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func bindViewModel() {
        let input = SwitchAccountVM.Input()
        let output = viewModel.transform(input)
        output.state.drive(self.rx.state).disposed(by: self.disposeBag)
    }
    
    ///Unused code
    func setupNavigation (){
        self.setTextNavigation(title: "List Daftar Akun", navigator: .close)
    }
    
    func setupButton(){
        button.set(type: .filled(custom: .alteaMainColor), title: "+ Tambahkan Akun")
        button.onTapped = { [weak self] in
            guard let self = self else { return }
            self.presentPanModal(self.popAddAccountView)
        }
    }
    
    func registerTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.registerNIB(with: MemberChooseCell.self)
    }
}

extension SwitchAccountVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataAccounts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueCell(with: MemberChooseCell.self) else {
            return UITableViewCell()}
        let target = dataAccounts[indexPath.row]
        cell.profileNameLabel.text = target.userName
        cell.profileRoleLabel.text = target.email
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.dismiss(animated: true, completion: .none)
        let target = dataAccounts[indexPath.row]
        CredentialManager.shared.setPrimaryCredentialFrom(email: target.email)
        self.goToHome?()
    }

}

extension SwitchAccountVC : PopAddDelegate{
    func goToCreateAccount() {
        self.onGoToRegister?()
        
    }
    
    func goToLogin() {
        self.onSignInTapped?()
    }
    
    
}
