//
//  ChangeProfileVC.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 08/04/21.
//

import UIKit
import RxSwift
import RxCocoa

class ChangeProfileVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ChangeProfileView {
    
    var viewModel: InitialChangeProfileVM!
    var onChangePhoneNumberTapped: ((String) -> Void)?
    var onChangeEmailAddressTapped: ((String) -> Void)?
    var onChangeDataPersonalTapped: (() -> Void)?
    var onChangeProfilePictureTapped: (() -> Void)?
    var onChangeAddressTapped: (() -> Void)?
    
    @IBOutlet weak var imageUserProfile: UIImageView!
    @IBOutlet weak var labelUserPhone: UILabel!
    @IBOutlet weak var labelUserEmail: UILabel!
    @IBOutlet weak var labelUserAddress: UILabel!
    
    @IBOutlet weak var buttonChangePhoneNumber: UIButton!
    @IBOutlet weak var buttonChangeEmailAddress: UIButton!
    @IBOutlet weak var buttonChangeDataPersonal: UIButton!
    
    @IBOutlet weak var containerDataView: UIView!
    @IBOutlet weak var formUserName: FormRow!
    @IBOutlet weak var formUserAge: FormRow!
    @IBOutlet weak var formBirthDate: FormRow!
    @IBOutlet weak var formUserGender: FormRow!
    @IBOutlet weak var formIdCard: FormRow!
    @IBOutlet weak var formPhoneNumber: FormRow!
    @IBOutlet weak var formEmailAddress: FormRow!
    @IBOutlet weak var formUserAddress: FormTextView!
    
    private let disposeBag = DisposeBag()
    private let viewDidLoadRelay = PublishRelay<Void?>()
    private let sendImageRelay =  BehaviorRelay<Media?>(value: nil)
    private let requestUpdateAvatar = BehaviorRelay<UpdateAvatarBody?>(value: nil)
    
    var modelProfile : ChangeProfileModel?
    var modelResponseUploadImage : UploadImageModel?
    
    var imageSend : UIImage?
    var imagePicker: UIImagePickerController?
    var alertSheet = UIAlertController()
    var imagePickerHandler = ImagePickerHandler(sourceType: .photoLibrary)
    lazy var filePickerHandler = FilePickerHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewDidLoadRelay.accept(())
        self.bindViewModel()
        self.circeImageView()
        self.showImageTapped()
        self.setupNavigation()
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewDidLoadRelay.accept(())
        self.bindViewModel()
//        if ((modelResponseUploadImage?.id?.isEmpty) != nil){
//            self.requestUpdateAvatar.accept(UpdateAvatarBody(avatar: self.modelResponseUploadImage?.id ?? ""))
//        } else {
//
//        }
    }
    
    private func setupNavigation(){
        self.setTextNavigation(title: "Ubah Profil", navigator: .back)
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.layer.masksToBounds = false
//        self.navigationController?.navigationBar.layer.shadowColor = UIColor.lightGray.cgColor
//        self.navigationController?.navigationBar.layer.shadowOpacity = 0.8
//        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2.0)
//        self.navigationController?.navigationBar.layer.shadowRadius = 2
    }
    
    func bindViewModel() {
        let input = InitialChangeProfileVM.Input(viewDidLoadRelay: self.viewDidLoadRelay.asObservable(), sendImage: self.sendImageRelay.asObservable(), updateAvatarInput: self.requestUpdateAvatar.asObservable())
        let output = viewModel.transform(input)
        
        output.state.drive(self.rx.state).disposed(by: self.disposeBag)
        output.userData.drive { (profileData) in
            self.modelProfile = profileData
            self.setForm(profileData)
        }.disposed(by: self.disposeBag)
        output.sendImageOutput.drive { (sendimageOuput) in
            self.modelResponseUploadImage = sendimageOuput
            self.requestUpdateAvatar.accept(UpdateAvatarBody(avatar: sendimageOuput?.id ?? ""))
        }.disposed(by: self.disposeBag)
        output.updateAvatarOutput.drive { (data) in
//            
        }.disposed(by: self.disposeBag)

    }
    
    func circeImageView() {
        imageUserProfile.layer.masksToBounds = true
        imageUserProfile.layer.cornerRadius = imageUserProfile.bounds.width / 2
        imageUserProfile.layer.borderWidth = 3
        if #available(iOS 13.0, *) {
            imageUserProfile.layer.borderColor = .init(red: 56, green: 104, blue: 176, alpha: 1)
        } else {
            // Fallback on earlier versions
        }
    }
    
    private func setForm(_ model : ChangeProfileModel?){
        guard let model = model else { return }
        
        if let url = URL(string: model.userImage ?? "") {
            self.imageUserProfile.kf.setImage(with: url)
        }
        
        self.labelUserPhone.text = model.phoneNumber
        self.labelUserEmail.text = model.email
        self.formUserName.title.text = "Nama"
        self.formUserName.value.text = model.username
        self.formUserAge.title.text = "Umur"
        self.formUserAge.value.text = "\(model.ageYear ?? 0) tahun \(model.ageMonth ?? 0) bulan"
        self.formIdCard.title.text = "No. KTP"
        self.formIdCard.value.text = model.idCard
        self.formUserGender.title.text = "Jenis Kelamin"
        self.formUserGender.value.text = model.gender
        self.formBirthDate.title.text = "Tanggal Lahir"
        self.formBirthDate.value.text = model.birthdate
        self.formEmailAddress.title.text = "Email"
        self.formEmailAddress.value.text = model.email
        self.formPhoneNumber.title.text = "Nomor Ponsel"
        self.formPhoneNumber.value.text = model.phoneNumber
//        self.formUserAddress.title.text = "Alamat"
//        self.formUserAddress.value.text = model.address
        self.labelUserAddress.text = model.address
    }
    
    func showImageTapped(){
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        self.imageUserProfile.isUserInteractionEnabled = true
        self.imageUserProfile.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        
        alertSheet = UIAlertController(title: "Unggah Photo Profile", message: nil, preferredStyle: .actionSheet)
        alertSheet.view.tintColor = UIColor.alteaMainColor
        alertSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (_) in
            let vc = UIImagePickerController()
            vc.sourceType = .camera
            vc.allowsEditing = true
            vc.delegate = self
            
            self.present(vc, animated: false, completion: nil)
        }))
        alertSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (_) in
            let vc = UIImagePickerController()
            vc.sourceType = .photoLibrary
            vc.allowsEditing = true
            vc.delegate = self
            
            self.present(vc, animated: false, completion: nil)
        }))
        
        alertSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alertSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let image = info[.originalImage] as? UIImage{
            self.imageSend = image
            guard let data = image.jpegData(compressionQuality: 0.2) else { return }
            self.sendImageRelay.accept(Media(key: "file", mimeType: "image/jpg", fileName: "\(arc4random()).jpeg", data: data))
        }
    }
    
    @IBAction func onChangePhoneNumberTapped(_ sender: Any) {
        self.onChangePhoneNumberTapped?(modelProfile?.phoneNumber ?? "")
    }
    
    @IBAction func onChangeEmailTapped(_ sender: Any) {
        self.onChangeEmailAddressTapped?(modelProfile?.email ?? "")
    }
    
    @IBAction func onChangeProfileData(_ sender: Any) {
        self.onChangeDataPersonalTapped?()
    }
    
    @IBAction func onChangeAddressTapped(_ sender: Any) {
        self.onChangeAddressTapped?()
    }
}
