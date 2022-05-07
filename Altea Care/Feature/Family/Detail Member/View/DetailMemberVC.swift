//
//  DetailMemberVC.swift
//  Altea Care
//
//  Created by Hedy on 11/08/21.
//

import UIKit
import RxSwift
import RxCocoa
import PanModal

protocol DetailDelegate : AnyObject{
    func deleteConfirm(id : String)
}

class DetailMemberVC: UIViewController, DetailMemberView {
    var idPatient: String!
    var viewModel: DetailMemberVM!
    var onChangeUserData: ((String) -> Void)?
    var onRegisterdAsAccount: ((String) -> Void)?
    var onDeleteMember: (() -> Void)?
    
    @IBOutlet weak var buttonDelete: UIButton!
    @IBOutlet weak var buttonChangeData: UIButton!
    @IBOutlet weak var buttonAddAsAccount: UIButton!
    
    @IBOutlet weak var containerMemberData: ACView!
    @IBOutlet weak var formUsername: FormRow!
    @IBOutlet weak var formBirthdate: FormRow!
    @IBOutlet weak var formGender: FormRow!
    @IBOutlet weak var formIdCard: FormRow!
    @IBOutlet weak var formDetailAlamat: FormTextView!
    @IBOutlet weak var formAge: FormRow!
    
    @IBOutlet weak var containerAlertBottonView: UIView!
    @IBOutlet weak var imageCheck: UIImageView!
    @IBOutlet weak var labelMessage: UILabel!
    @IBOutlet weak var buttonCloseAlert: NSLayoutConstraint!
    
    private let disposeBag = DisposeBag()
    
    private var model : DetailMemberModel? = nil
    private let viewDidLoadRelay = PublishRelay<Void>()
    private let detailMemberRequest = BehaviorRelay<DetailMemberBody?>(value: nil)
    private let deletMemberRequest = BehaviorRelay<DeleteMemberBody?>(value: nil)
    
    private lazy var deleteDrawerView : DeleteConfirmVC = {
        let vc = DeleteConfirmVC()
        vc.delegate = self
        return vc
    }()
    
    private lazy var changeProfileUnabledVC : UnableToUpdateProfileVC = {
        let vc = UnableToUpdateProfileVC()
        return vc
    }()
    
    weak var delegate : DetailDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSecondaryButton(button: buttonAddAsAccount)
    
        self.bindViewModel()
        self.setupNavigation()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.viewDidLoadRelay.accept(())
        self.detailMemberRequest.accept(DetailMemberBody(id: idPatient))
    }

    func bindViewModel() {
        let input = DetailMemberVM.Input(detailMemberInput: self.detailMemberRequest.asObservable(), deletMemberInput: self.deletMemberRequest.asObservable(), viewDidloadRelay: self.viewDidLoadRelay.asObservable())
        let output = viewModel.transform(input)
        output.state.drive(self.rx.state).disposed(by: self.disposeBag)
        output.detailMemberOutput.drive { (data) in
            self.model = data
            self.setupFormData(self.model)
        }.disposed(by: self.disposeBag)
    }
    
    func setupFormData(_ model : DetailMemberModel?){
        self.formUsername.title.text = "Nama"
        self.formUsername.value.text = "\(model?.firstName ?? "") \(model?.lastName ?? "")"
        self.formAge.title.text = "Usia"
        self.formAge.value.text = "\(model?.age ?? "") tahun"
        self.formBirthdate.value.text = "\(model?.dob ?? "")"
        self.formBirthdate.title.text = "Tanggal Lahir"
        self.formGender.value.text = "\(model?.gender ?? "")"
        self.formGender.title.text = "Jenis Kelamin"
        self.formIdCard.title.text = "NO KTP"
        self.formIdCard.value.text = "\(model?.idCardKtp ?? "")"
        self.formDetailAlamat.title.text = "Alamat"
        self.formDetailAlamat.value.text = "\(model?.address ?? "")"
    }

    @IBAction func buttonChangeDataTapped(_ sender: Any) {
        if model?.extPatientId == nil{
            self.onChangeUserData?(idPatient)
        }else{
            presentPanModal(changeProfileUnabledVC)
        }
    }
    
    @IBAction func buttonRegisterAsAccountTapped(_ sender: Any) {
        self.onRegisterdAsAccount?(idPatient)
    }
    
    func setupNavigation (){
        self.setTextNavigation(title: "Rincian Keluarga", navigator: .back)
    }
    
    @IBAction func buttonCloseAlert(_ sender: Any) {
        self.containerAlertBottonView.isHidden = true
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        if model?.extPatientId == nil{
            presentPanModal(deleteDrawerView)
        }else{
            presentPanModal(changeProfileUnabledVC)
        }
        
    }
}

extension DetailMemberVC : DeleteConfirmDelegate{
    func delete(id: String) {
        self.deletMemberRequest.accept(DeleteMemberBody(id: idPatient))
        self.onDeleteMember?()
    }
    
    func backToVC() {
        
    }
    
    
}
