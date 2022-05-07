//
//  TermConditionCheckVC.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 12/03/21.
//

import UIKit
import WebKit
import RxSwift
import RxCocoa

class TermConditionCheckVC: UIViewController, TermAndConditionView, WKUIDelegate {
    
    var onButtonSubmitTapped: (() -> Void)?
    var viewModel: TermAndConditionVM!
    var onTermChecklish: (() -> Void)?
    
    @IBOutlet weak var termConditionLabel: UILabel!
    
    @IBOutlet weak var containerViewFailed: UIView!
    @IBOutlet weak var buttonClose: UIButton!
    @IBOutlet weak var labelResponseFailed: UILabel!
    @IBOutlet weak var viewContainerWebView: UIView!
    @IBOutlet weak var imageAlteaIcon: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var labelAcceptedTermCondition: UILabel!
    @IBOutlet weak var buttonCheckBox: UIButton!
    @IBOutlet weak var buttonNext: UIButton!
    
    private let disposeBag = DisposeBag()
    
    private let requestRegister = BehaviorRelay<RegisterBody?>(value: nil)
    private let requestSendVerificationEmail = BehaviorRelay<SendVerificationEmailBody?>(value: nil)
    private let viewDidLoadRelay = PublishRelay<Void>()
    var statusCheckButton = 0
    
    var registerModel : RegisterModel? = nil
    var registerResponse : RegisterResponse? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bindViewModel()
        self.setupInitButton()
        self.setupNavigation()
        self.viewDidLoadRelay.accept(())
    }
    
    func bindViewModel() {
        
        let input = TermAndConditionVM.Input( sendVerificationEmailRequest: requestSendVerificationEmail.asObservable(), viewDidLoadRelay: viewDidLoadRelay.asObservable(), registerRequest: requestRegister.asObservable())
        let output = viewModel.transform(input)
        output.state.drive(self.rx.state).disposed(by: self.disposeBag)
        output.registerOutput.drive { (data) in
            self.registerModel = data
            if data?.status == true{
                Preference.set(value: self.registerModel?.data?.accessToken, forKey: .AccessTokenKey)
                Preference.set(value: self.registerModel?.data?.refreshToken, forKey: .AccessRefreshTokenKey)
                Preference.set(value: self.registerModel?.data?.deviceId, forKey: .DeviceId)
                self.onButtonSubmitTapped?()
            } else if data?.status == false {
                self.setupViewFailed(message: data?.message ?? "")
            }
            
            self.viewModel.requestSendVerificationEmail(body: SendVerificationEmailBody(email: nil, phone: "\(Preference.getString(forKey: .UserPhone) ?? "")"))
            
        }.disposed(by: self.disposeBag)
        output.termCondition.drive { (termConditionData) in
            self.setupLabelTermCondition(model: termConditionData)
        }.disposed(by: self.disposeBag)
    }
    
    func setupViewFailed(message : String){
        self.containerViewFailed.isHidden = false
        self.labelResponseFailed.text = message
        self.containerViewFailed.backgroundColor = UIColor.red
    }
    
    func setupInitButton(){
        self.buttonNext.isEnabled = false
        self.setupActiveButton(button: buttonNext)
        self.buttonNext.backgroundColor = UIColor.gray
    }
    
    func setupLabelTermCondition(model : TermAndConditionModel?){
        self.termConditionLabel.attributedText = model?.text.htmlAttributedString()
    }
    
    @IBAction func setupCloseContainerView(_ sender: Any) {
        self.containerViewFailed.isHidden = true
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        if statusCheckButton == 0{
            statusCheckButton = 1
            buttonCheckBox.setImage(#imageLiteral(resourceName: "uncheckIcon"), for: .normal)
            buttonNext.backgroundColor = UIColor.gray
            
        } else if statusCheckButton == 1 {
            buttonCheckBox.setImage(#imageLiteral(resourceName: "checkedIcon"), for: .normal)
            statusCheckButton = 0
            buttonNext.backgroundColor = UIColor.alteaMainColor
            buttonNext.isEnabled = true
        }
    }
    
    @IBAction func acceptButtonTapped(_ sender: Any) {
        let data = RegisterBody(
            email: Preference.getString(forKey: .UserEmail) ?? "",
            phone: Preference.getString(forKey: .UserPhone) ?? "",
            password: UserDefaults.standard.string(forKey: "password") ?? "",
            password_confirmation: UserDefaults.standard.string(forKey: "password") ?? "",
            first_name: UserDefaults.standard.string(forKey: "firstname") ?? "",
            last_name: UserDefaults.standard.string(forKey: "lastname") ?? "",
            birth_date: UserDefaults.standard.string(forKey: "Date") ?? "",
            gender: UserDefaults.standard.string(forKey: "gender") ?? "",
            birth_place: UserDefaults.standard.string(forKey: "city") ?? "",
            birth_country: UserDefaults.standard.string(forKey: "countryId") ?? "")
        self.requestRegister.accept(data)
    }
    
    func setupNavigation(){
        self.setTextNavigation(title: "Syarat dan Ketentuan", navigator: .back)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layer.masksToBounds = false
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.lightGray.cgColor
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.8
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 2
    }
}
