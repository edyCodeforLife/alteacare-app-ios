//
//  AccountVC.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import UIKit
import RxSwift
import RxCocoa
import PanModal

class AccountVC: UIViewController, AccountView, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    var signOutTapped: (() -> Void)?
    var goToChangeProfile: (() -> Void)?
    var goToSettingAccount: (() -> Void)?
    var goToFAQ: (() -> Void)?
    var goToContactUs: (() -> Void)?
    var goToTermCondition: (() -> Void)?
    var goToSignOut: (() -> Void)?
    var goToListFamilyMember: (() -> Void)?
    var goToRegister: (() -> Void)?
    var goToLoginIn: (() -> Void)?
    
    @IBOutlet weak var versionApkLabel: UILabel!
    @IBOutlet weak var buttonTambahkanAkun: NSLayoutConstraint!
    @IBOutlet weak var labelEmailUser: UILabel!
    @IBOutlet weak var labelUsername: UILabel!
    @IBOutlet weak var imageProfileUser: UIImageView!
    @IBOutlet weak var tableViewOptions: UITableView!
    @IBOutlet weak var logoutContainerView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var buttonLogout: UIButton!
    @IBOutlet weak var tableViewTop: UITableView!
    
    var viewModel: AccountVM!
    
    var alertSheet = UIAlertController()
    
    let kVersion = "CFBundleShortVersionString"
    let kBuildNumber = "CFBundleVersion"
    
    var email : String?
    
    private var model = [AccountOptionModel](){
        didSet {
            self.tableViewOptions.reloadData()
        }
    }
    private var errorAccountData: Bool? {
        didSet {
            if let isError = errorAccountData, isError {
                signOutTapped?()
            }
        }
    }
    
    private var modelOptionTentang = [AccountOptionModel](){
        didSet {
            self.tableViewTop.reloadData()
        }
    }
    
    
    private lazy var popAddAccountView : PopAddAccountVC = {
        let vc = PopAddAccountVC()
        vc.delegate = self
        return vc
    }()
    
    private let disposeBag = DisposeBag()
    private let viewDidLoadRelay = PublishRelay<Void>()
    private let requestLogout = BehaviorRelay<LogoutBody?>(value: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModel()
        self.circeImageView()
        self.setupOptionsList()
        self.setupTableView()
        self.setupLabelVersion()
        self.viewDidLoadRelay.accept(())
        self.setupLogoutButton()
        
        if #available(iOS 15.0, *) {
            UITableView.appearance().sectionHeaderTopPadding = 0
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        self.viewDidLoadRelay.accept(())
    }
    
    func bindViewModel() {
        let input = AccountVM.Input(viewDidLoadRelay: self.viewDidLoadRelay.asObservable(), logoutRequest: requestLogout.asObservable())
        let output = viewModel.transform(input)
        output.state.drive(self.rx.state).disposed(by: self.disposeBag)
        output.accountData.drive { (model) in
            self.setupDataUI(dataUser: model)
            self.email = model?.email
        }.disposed(by: self.disposeBag)
        output.logoutOutput.drive { (model) in
            if (model?.status)! {
                self.defaultAnalyticsService.inactive()
                CredentialManager.shared.removeUserCredentialFrom(email: self.email ?? "")
                let data = CredentialManager.shared.getCredentials()
                if data.isEmpty {
                    Preference.removeString(forKey: .AccessTokenKey)
                    Preference.removeString(forKey: .AccessRefreshTokenKey)
                    self.signOutTapped?()
                } else {
                    CredentialManager.shared.setPrimaryCredentialFrom(email: data[0].email)
                }
                self.signOutTapped?()
            }
        }.disposed(by: self.disposeBag)
        output.errorAccountOutput.drive { [weak self] data in
            self?.errorAccountData = data
        }.disposed(by: self.disposeBag)
        
    }
    
    private func checkData(){
        let token = Preference.getString(forKey: .AccessTokenKey) ?? ""
        if token.isEmpty {
            self.signOutTapped?()
        }
    }
    
    func setupDataUI(dataUser : AccountDataModel?){
        self.labelUsername.text = dataUser?.userName
        self.labelEmailUser.text = dataUser?.email
        
        if let url = URL(string: dataUser?.userPhoto ?? "") {
            self.imageProfileUser.kf.setImage(with: url)
        }
    }
    
    func setupLabelVersion(){
        versionApkLabel.text = getVersiont()
    }
    
    func getVersiont() -> String{
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary[kVersion] as! String
        let build = dictionary[kBuildNumber] as! String
        
        return "\(version) build \(build)"
    }
    
    private func setupTableView(){
        self.tableViewOptions.delegate = self
        self.tableViewOptions.dataSource = self
        
        self.tableViewTop.delegate = self
        self.tableViewTop.dataSource = self
        
        let nib = UINib(nibName: "OptionsCell", bundle: nil)
        self.tableViewOptions.register(nib, forCellReuseIdentifier: "optionsCell")
        
        self.tableViewTop.register(nib, forCellReuseIdentifier: "optionsCell")
    }
    
    func setupOptionsList(){
        modelOptionTentang.append(AccountOptionModel(title: "Akun", option: [ProfileOption(tittle: "Ubah Profile", imageOption: #imageLiteral(resourceName: "SettingAccount"), isHiddenChevron: false, handler: { [self] in
            self.goToChangeProfile?()
        }),
        ProfileOption(tittle: "Keluarga Saya", imageOption: #imageLiteral(resourceName: "IconKeluarga"), isHiddenChevron: false, handler: {
//            self.showToast(message: "Comming Soon")
            self.goToListFamilyMember?()
        }),
        ProfileOption(tittle: "Pengaturan", imageOption: #imageLiteral(resourceName: "IconSetting"), isHiddenChevron: false, handler: {
            self.goToSettingAccount?()
        })
        ]))
        
        model.append(AccountOptionModel(title: "Tentang", option: [ProfileOption(tittle: "Pertanyaan sering diajukan", imageOption: #imageLiteral(resourceName: "IconFAQ"), isHiddenChevron: false, handler: {
            self.goToFAQ?()
        }),
        ProfileOption(tittle: "Kontak AlteaCare", imageOption: #imageLiteral(resourceName: "IconContactUS"), isHiddenChevron: false, handler: {
            self.goToContactUs?()
        }),
        ProfileOption(tittle: "Syarat dan Ketentuan", imageOption: #imageLiteral(resourceName: "IconTermCondition"), isHiddenChevron: false, handler: {
            self.goToTermCondition?()
        })
        ]))
    }
    
    func circeImageView() {
        imageProfileUser.layer.masksToBounds = true
        imageProfileUser.layer.cornerRadius = imageProfileUser.bounds.width / 2
        imageProfileUser.layer.borderWidth = 3
        if #available(iOS 13.0, *) {
            imageProfileUser.layer.borderColor = .init(red: 56, green: 104, blue: 176, alpha: 1)
        } else {
            // Fallback on earlier versions
        }
    }
    
    @IBAction func buttonAddTapped(_ sender: Any) {
        presentPanModal(popAddAccountView)
    }
    
    func setupLogoutButton(){
        self.buttonLogout.isUserInteractionEnabled = false
        self.buttonLogout.titleLabel?.font = UIFont.font(size: 14, fontType: .bold)
        self.logoutContainerView.addTapGestureRecognizer(action: {
            let vc = LogoutConfirmVC()
            vc.onApproveTapped = { [weak self] in
                guard let self = self else {return}
                self.viewModel.requestLogout(body: LogoutBody())
            }
            self.presentPanModal(vc)
        })
    }
}

//MARK: - Table View Data Source
extension AccountVC : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model[section].option.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == tableViewTop {
            let cell = tableView.dequeueReusableCell(withIdentifier: "optionsCell", for: indexPath) as! OptionsCell
            
            let model = self.modelOptionTentang[indexPath.section].option[indexPath.row]
            cell.configure(with: model)
            cell.selectionStyle = .none
            cell.isHighlighted = false
            
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "optionsCell", for: indexPath) as! OptionsCell
        
        let model = self.model[indexPath.section].option[indexPath.row]
        cell.configure(with: model)
        cell.selectionStyle = .none
        cell.isHighlighted = false
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView == tableViewTop{
            let section = modelOptionTentang[section]
            return section.title
        }
        
        if tableView == tableViewOptions{
            let section = model[section]
            return section.title
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header =  view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.alteaBlueMain
        header.textLabel?.font = .boldSystemFont(ofSize: 15)
        header.tintColor = UIColor.softblue
    }

}

//MARK: - Table View Delegate
extension AccountVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tableViewTop{
            let model = self.modelOptionTentang[indexPath.section].option[indexPath.row]
            model.handler()
        }
        
        if tableView == tableViewOptions{
            let model = self.model[indexPath.section].option[indexPath.row]
            model.handler()
        }
    }
}

extension AccountVC : PopAddDelegate{
    func goToCreateAccount() {
        self.goToRegister?()
    }
    
    func goToLogin() {
        self.goToLoginIn?()
    }
}
