//
//  ContactUsVC.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 08/04/21.
//

import UIKit
import RxSwift
import RxCocoa

class ContactUsVC: UIViewController, ContactUsView, UIPickerViewDelegate, UIPickerViewDataSource{
    
    var onSendButtonTapped: (() -> Void)?
    @IBOutlet weak var exclamationUserName: UIImageView!
    @IBOutlet weak var labelExclamationUsername: UILabel!
    @IBOutlet weak var exclamationUserAddress: UIImageView!
    @IBOutlet weak var labelExclamationUserEmailaddress: UILabel!
    @IBOutlet weak var exclamationPhoneNumber: UIImageView!
    @IBOutlet weak var labelExclamationPhoneNumber: UILabel!
    @IBOutlet weak var labelExclamationMessageType: UILabel!
    @IBOutlet weak var exclamationMessageCategory: UIImageView!
    @IBOutlet weak var exclamationMessage: UIImageView!
    @IBOutlet weak var labelExclamationMessage: UILabel!
    
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var labelPhoneNumber: UILabel!
    @IBOutlet weak var tfPhoneNumber: UITextField!
    @IBOutlet weak var labelStaticInitialPhoneNumber: UILabel!
    @IBOutlet weak var labelCategoryMessage: UILabel!
    @IBOutlet weak var tfCategoryMessage: UITextField!{
        didSet {
            tfCategoryMessage.setIcon(#imageLiteral(resourceName: "DownChevronAltea"))
        }
    }
    @IBOutlet weak var labelMessage: UILabel!
    @IBOutlet weak var tfMessageUser: UITextField!
    
    @IBOutlet weak var buttonSend: UIButton!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var labelTileCallCenter: UILabel!
    @IBOutlet weak var labelCallCenterEmail: UILabel!
    
    @IBOutlet weak var imageIconCallCenter: UIImageView!
    @IBOutlet weak var labelHubungiWA: UILabel!
    
    @IBOutlet weak var labelPhoneNumberCC: UILabel!
    
    @IBOutlet weak var buttonCall: UIButton!
    
    var viewModel: ContactUsVM!
    private let disposeBag = DisposeBag()
    private let viewDidLoadRelay = PublishRelay<Void>()
    private var messageTypeModel : MessageTypeModel? = nil
    private var informationCenterModel : InformationCenterModel? = nil
    
    var messageTypeSelected: String? = ""
    
    let pickerViewSelectMessageType = UIPickerView()
    
    var sendMessageModel : ContactUsModel? = nil
    
    private let sendMessageInput = BehaviorRelay<SendMessageBody?>(value: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModel()
        self.setupNavigation()
        self.bindViewModel()
        self.setupButton()
        self.setupSecondaryButton(button: buttonSend)
        self.viewDidLoadRelay.accept(())
        self.setupSecondaryButton(button: buttonCall)
    }
    
    func bindViewModel() {
        let input = ContactUsVM.Input(viewDidLoadRelay: self.viewDidLoadRelay.asObservable(), sendMessageInput: self.sendMessageInput.asObservable())
        let output = viewModel.transform(input)
        output.state.drive(self.rx.state).disposed(by: self.disposeBag)
        output.getMessageTypeOutput.drive { (data) in
            self.messageTypeModel = data
        }.disposed(by: self.disposeBag)
        output.getInformationCenterOutput.drive { (data) in
            self.informationCenterModel = data
            UserDefaults.standard.setValue(self.informationCenterModel?.data.content.phone, forKey: "NomorCC")
            self.setupUIInfomationCenter(model: self.informationCenterModel)
        }.disposed(by: self.disposeBag)
        output.sendMessageOutput.drive { (data) in
            self.sendMessageModel = data
            if data?.status == true{
                self.onSendButtonTapped?()
            }
        }.disposed(by: self.disposeBag)
        self.createPickerView()
    }
    
    @IBAction func validationName(_ sender: Any) {
        let name = tfName.text ?? ""
        exclamationUserName.isHidden = false
        labelExclamationUsername.isHidden = false
        
        if name.isNotEmpty {
            exclamationUserName.isHidden = true
            labelExclamationUsername.isHidden = true
        } else {
            exclamationUserName.isHidden = false
            labelExclamationUsername.isHidden = false
            labelExclamationUsername.text = "Nama tidak boleh kosong"
        }
    }
    
    @IBAction func validationEmail(_ sender: Any) {
        let email =  tfEmail.text ?? ""
        
        if email.isValidEmail() {
            exclamationUserAddress.isHidden = true
            labelExclamationUserEmailaddress.isHidden = true
        } else {
            exclamationUserAddress.isHidden = false
            labelExclamationUserEmailaddress.isHidden = false
            labelExclamationUserEmailaddress.text = "Format email belum sesuai"
        }
        
        if email.isEmpty {
            exclamationUserAddress.isHidden = false
            labelExclamationUserEmailaddress.isHidden = false
            labelExclamationUserEmailaddress.text = "Email tidak boleh kosong"
        } else {
            exclamationUserAddress.isHidden = true
            labelExclamationUserEmailaddress.isHidden = true
        }
    }
    
    @IBAction func validationPhoneNumber(_ sender: Any) {
        let phoneNumber = tfPhoneNumber.text ?? ""
        
        if phoneNumber.isEmpty {
            exclamationPhoneNumber.isHidden = false
            labelExclamationPhoneNumber.isHidden = false
            labelExclamationPhoneNumber.text = "Nomor kontak tidak boleh kosong"
        } else {
            exclamationPhoneNumber.isHidden = true
            labelExclamationPhoneNumber.isHidden = true
        }
        
        if phoneNumber.isValidPhone(){
            exclamationPhoneNumber.isHidden = true
            labelExclamationPhoneNumber.isHidden = true
        } else {
            exclamationPhoneNumber.isHidden = false
            labelExclamationPhoneNumber.isHidden = false
            labelExclamationPhoneNumber.text = "Nomor kontak belum sesuai"
        }
    }
    
    @IBAction func validationMessageCategory(_ sender: Any) {
        let categoryMessage = tfCategoryMessage.text ?? ""
        
        if categoryMessage.isEmpty {
            exclamationMessageCategory.isHidden = false
            labelExclamationMessageType.isHidden = false
            labelExclamationMessageType.text = "Kategori pesan tidak boleh kosong"
        } else {
            exclamationMessageCategory.isHidden = true
            labelExclamationMessageType.isHidden = true
        }
    }
    
    @IBAction func validationMessage(_ sender: Any) {
        let message = tfMessageUser.text ?? ""
        
        if message.isEmpty {
            exclamationMessage.isHidden = false
            labelExclamationMessage.isHidden = false
            labelExclamationMessage.text = "Pesan tidak boleh kosong"
        } else {
            exclamationMessage.isHidden = true
            labelExclamationMessage.isHidden = true
        }
    }
    
    func setupUIInfomationCenter(model : InformationCenterModel?){
        labelCallCenterEmail.text = model?.data.content.email
        labelPhoneNumberCC.text = model?.data.content.phone
    }
    
    
    func createPickerView(){
        pickerViewSelectMessageType.delegate = self
        tfCategoryMessage.inputView = pickerViewSelectMessageType
    }
    
    //MARK: - Setup Picker for Gender
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pickerViewSelectMessageType{
            return messageTypeModel?.data?.count ?? 0
        }
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pickerViewSelectMessageType {
            return messageTypeModel?.data?[row].name
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pickerViewSelectMessageType{
            let messageId =  messageTypeModel?.data?[row].id
            messageTypeSelected = messageTypeModel?.data?[row].name
            tfCategoryMessage.text = messageTypeModel?.data?[row].name
            UserDefaults.standard.set(messageId, forKey: "messageId")
            
            exclamationMessageCategory.isHidden = true
            labelExclamationMessageType.isHidden = true
        }
    }
    
    @IBAction func sendButtonTapped(_ sender: Any) {
        let numberPhone = tfPhoneNumber.text ?? ""
        let userMessage = tfMessageUser.text ?? ""
        let categoryMessage = tfCategoryMessage.text ?? ""
        let username = tfName.text ?? ""
        let useremail =  tfEmail.text ?? ""
        
        if numberPhone.isEmpty{
            exclamationPhoneNumber.isHidden = false
            labelExclamationPhoneNumber.isHidden = false
            labelExclamationPhoneNumber.text = "Nomor kontak tidak boleh kosong"
        }
        
        if userMessage.isEmpty{
            exclamationMessage.isHidden = false
            labelExclamationMessage.isHidden = false
            labelExclamationMessage.text = "Pesan tidak boleh kosong"
        }
        
        if categoryMessage.isEmpty{
            exclamationMessageCategory.isHidden = false
            labelExclamationMessageType.isHidden = false
            labelExclamationMessageType.text = "Kategori pesan tidak boleh kosong"
        }
        
        if username.isEmpty {
            exclamationUserName.isHidden = false
            labelExclamationUsername.isHidden = false
            labelExclamationUsername.text = "Nama tidak boleh kosong"
        }
        
        if useremail.isEmpty{
            exclamationUserAddress.isHidden = false
            labelExclamationUserEmailaddress.isHidden = false
            labelExclamationUserEmailaddress.text = "Email tidak boleh kosong"
        }
        
        if numberPhone.isEmpty == false && userMessage.isEmpty == false && categoryMessage.isEmpty == false && username.isEmpty == false && useremail.isEmpty == false && useremail.isValidEmail() && numberPhone.isValidPhone() {
            let data = SendMessageBody(message_type: UserDefaults.standard.string(forKey: "messageId") ?? "",
                                       message: userMessage,
                                       name: username,
                                       phone: numberPhone,
                                       email: useremail)
            
            self.sendMessageInput.accept(data)
        }
    }
    
    func setupButton(){
      
    }
    
    @IBAction func buttonTappedWa(_ sender: Any) {
        // 1
        let urlWhats = "https://wa.me/\(UserDefaults.standard.string(forKey: "NomorCC") ?? "")"
        // 2
        if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) {
          // 3
          if let whatsappURL = NSURL(string: urlString) {
            // 4
            if UIApplication.shared.canOpenURL(whatsappURL as URL) {
              // 5
              UIApplication.shared.open(whatsappURL as URL, options: [:], completionHandler: nil)
            } else {
              // 6
            }
          }
        }
    }
    
    private func setupNavigation(){
        self.setTextNavigation(title: "Kontak Altea Care", navigator: .back)
    }
}
