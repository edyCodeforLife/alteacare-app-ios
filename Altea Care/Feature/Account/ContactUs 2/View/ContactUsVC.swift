//
//  ContactUsVC.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 08/04/21.
//

import UIKit
import RxSwift
import RxCocoa

class ContactUsVC: UIViewController, ContactUsView {
    
    var onSendButtonTapped: (() -> Void)?
    
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var labelPhoneNumber: UILabel!
    @IBOutlet weak var tfPhoneNumber: UITextField!
    @IBOutlet weak var labelStaticInitialPhoneNumber: UILabel!
    @IBOutlet weak var labelCategoryMessage: UILabel!
    @IBOutlet weak var tfCategoryMessage: UITextField!
    @IBOutlet weak var labelMessage: UILabel!
    @IBOutlet weak var tfMessageUser: UITextField!
    
    @IBOutlet weak var buttonSend: UIButton!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var labelTileCallCenter: UILabel!
    @IBOutlet weak var labelCallCenterEmail: UILabel!
    
    @IBOutlet weak var imageIconCallCenter: UIImageView!
    @IBOutlet weak var labelHubungiWA: UILabel!
    
    @IBOutlet weak var labelPhoneNumberCC: UILabel!
    
    @IBOutlet weak var buttonCall: ACButton!
    
    var viewModel: ContactUsVM!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigation()

        self.bindViewModel()
        self.setupButton()
        self.setupSecondaryButton(button: buttonSend)
    }
    
    func bindViewModel() {
        let input = ContactUsVM.Input()
        let output = viewModel.transform(input)
        output.state.drive(self.rx.state).disposed(by: self.disposeBag)
    }
    
    @IBAction func sendButtonTapped(_ sender: Any) {
        self.onSendButtonTapped?()
    }
    
    func setupButton(){
        buttonCall.leftIcon.image = #imageLiteral(resourceName: "IconCallPhone")
        buttonCall.layer.cornerRadius = 8
        buttonCall.set(type: .bordered(custom: .alteaGreenMain), title: "Telepon")
    }
    
    private func setupNavigation(){
        self.setTextNavigation(title: "Kontak Altea Care", navigator: .back)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layer.masksToBounds = false
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.lightGray.cgColor
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.8
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 2
    }
}
