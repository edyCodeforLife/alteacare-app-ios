//
//  AddMemberVC.swift
//  Altea Care
//
//  Created by Hedy on 11/08/21.
//

import UIKit
import RxSwift
import RxCocoa
import PanModal
class AddMemberVC: UIViewController, AddMemberView {
    @IBOutlet weak var relationTF: UITextField!
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var genderTF: UITextField!
    @IBOutlet weak var dobTF: UITextField!
    @IBOutlet weak var placeOfBirthTF: UITextField!
    @IBOutlet weak var cityofBirthTF: UITextField!
    @IBOutlet weak var citizenshipTF: UITextField!
    @IBOutlet weak var noKTPTF: UITextField!
    @IBOutlet weak var addressTF: UITextField!
    
    @IBOutlet weak var relationContainer : ACView!
    @IBOutlet weak var firstNameContainer : ACView!
    @IBOutlet weak var lastNameContainer : ACView!
    @IBOutlet weak var genderContainer : ACView!
    @IBOutlet weak var dobContainer : ACView!
    @IBOutlet weak var placeOfBirthContainer : ACView!
    @IBOutlet weak var cityofBirthContainer : ACView!
    @IBOutlet weak var citizenshipContainer : ACView!
    @IBOutlet weak var noKTPContainer : ACView!
    @IBOutlet weak var addressContainer : ACView!
    
    @IBOutlet weak var relationErrorView : UIView!
    @IBOutlet weak var firstNameErrorView : UIView!
    @IBOutlet weak var lastNameErrorView : UIView!
    @IBOutlet weak var genderErrorView : UIView!
    @IBOutlet weak var dobErrorView : UIView!
    @IBOutlet weak var placeOfBirthErrorView : UIView!
    @IBOutlet weak var citizenshipErrorView : UIView!
    @IBOutlet weak var noKTPErrorView : UIView!
    @IBOutlet weak var addressErrorView : UIView!
    
    @IBOutlet weak var relationErrorLabel : UILabel!
    @IBOutlet weak var firstNameErrorLabel : UILabel!
    @IBOutlet weak var lastNameErrorLabel : UILabel!
    @IBOutlet weak var genderErrorLabel : UILabel!
    @IBOutlet weak var dobErrorLabel : UILabel!
    @IBOutlet weak var placeOfBirthErrorLabel : UILabel!
    @IBOutlet weak var citizenshipErrorLabel : UILabel!
    @IBOutlet weak var noKTPErrorLabel : UILabel!
    @IBOutlet weak var addressErrorLabel : UILabel!
    @IBOutlet weak var continueButton: ACButton!
    
    var addProfileTapped: (() -> Void)?
    var chooseAddressTapped: (() -> Void)?
    var registMemberTapped: ((AddMemberBody) -> Void)?
    var viewModel: AddMemberVM!
    var selectedAddressID: String?{
        didSet{
            address = selectedAddressID
        }
    }
    var selectedAddress: String?
    var isRoot: Bool!
    
    private let disposeBag = DisposeBag()
    private let viewDidLoadRelay = PublishRelay<Void>()
    private let addMemberRequest = BehaviorRelay<AddMemberBody?>(value: nil)
    
    private var countryData : CountryModel? = nil{
        didSet{
            guard let data = countryData?.data else {return}
            countryListString = data.map {$0.name}
        }
    }
    
    private var addMemberData : AddMemberModel? = nil
    
    private var errorAddMember : Error? {
        didSet {
            guard let error = errorAddMember else { return }
            noKTPContainer.errorBorder(isError: true)
            noKTPErrorLabel.text = error.readableError
            noKTPErrorView.isHidden = false
        }
    }
    
    private var familyRelationData : FamilyRelationModel? = nil{
        didSet{
            guard let data = familyRelationData?.data else {return}
            familyRelationList = data.map {$0.name}
        }
    }
    
    private var familyRelationList = [String]()
    private var countryListString = [String]()
    //dummy?
    var relation: String?
    var firstName: String?
    var lastName: String?
    var gender: String?
    var dob: String?
    var placeOfBirth: String?
    var cityofBirth: String?
    var citizenship: String?
    var noKTP: String?
    var address: String?
    
    private lazy var previewMember: PreviewAddedFamVC = {
        let vc = PreviewAddedFamVC(name: "\(firstName ?? "") \(lastName ?? "")", dob: dobTF.text ?? "", birth: placeOfBirthTF.text ?? "", citizenship: citizenshipTF.text ?? "", gender: genderTF.text ?? "")
        vc.delegate = self
        return vc
    }()
    
    private lazy var addAsAccount: AddProfileAsAccountVC = {
        let vc = AddProfileAsAccountVC()
        vc.delegate = self
        return vc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRx()
        bindViewModel()
        viewDidLoadRelay.accept(())
        initView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigation()
        setupUI()
        setupDefaultCountry()
    }
    
    func bindViewModel() {
        let input = AddMemberVM.Input(viewDidLoadRelay: viewDidLoadRelay.asObservable(),
                                      addMemberRequest: addMemberRequest.asObservable())
        let output = viewModel.transform(input)
        
        disposeBag.insert([
            output.state.drive(self.rx.state),
            
            output.familyRelation.drive { [weak self](relations) in
                self?.familyRelationData = relations
            },
            
            output.countryData.drive { [weak self](countries) in
                self?.countryData = countries
                /// In here
            },
            
            output.addMemberOutput.drive { (data) in
                self.addProfileTapped?()
            },
            
            output.errorAddMemberOutput.drive { [weak self](error) in
                self?.errorAddMember = error
            }
        ])
    }
    
    private func setupDefaultCountry(){
        let dataDefaultCountry = self.countryData?.data.filter{
            $0.name.lowercased().contains("indonesia")
        }
        self.placeOfBirth = dataDefaultCountry?[0].countryId
        self.citizenship = dataDefaultCountry?[0].countryId
        placeOfBirthTF.text = "Indonesia"
        citizenshipTF.text = "Indonesia"
        
        
        placeOfBirthTF.sendActions(for: .valueChanged)
    }
    
    private func initView(){
        relationTF.text = ""
        firstNameTF.text = ""
        lastNameTF.text = ""
        genderTF.text = ""
        dobTF.text = ""
//        placeOfBirthTF.text = ""
        cityofBirthTF.text = ""
//        citizenshipTF.text = ""
        noKTPTF.text = ""
        addressTF.text = ""
        
        relation = nil
        firstName = nil
        lastName = nil
        gender = nil
//        dob = nil
        placeOfBirth = nil
        cityofBirth = nil
        citizenship = nil
        noKTP = nil
        address = nil
    }
    // MARK: - SETUP
    private func setupUI(){
        continueButton.set(type: .filled(custom: .alteaMainColor), title: "Lanjutkan")
        continueButton.onTapped = { [weak self] in
            guard let self = self else { return }
            self.continueTapped()
        }
        
        
        relationTF.addDropDownViewer()
        genderTF.addDropDownViewer()
        placeOfBirthTF.addDropDownViewer()
        addressTF.addDropDownViewer()
        citizenshipTF.addDropDownViewer()
        relationTF.delegate = self
        genderTF.delegate = self
        placeOfBirthTF.delegate = self
        addressTF.delegate = self
        dobTF.delegate = self
        citizenshipTF.delegate = self
        
        //after add address
        addressTF.text = selectedAddress
    }
    
    private func setupNavigation() {
        if isRoot == true {
            self.setTextNavigation(title: "Tambah Daftar Keluarga", navigator: .close)
        }else {
            self.setTextNavigation(title: "Tambah Daftar Keluarga", navigator: .back)
        }
       
    }
    
    // MARK: - VALIDATION
    
    private func setupRx(){
        disposeBag.insert([
            firstNameTF.rx.text
                .skip(2)
                .subscribe(onNext: { [weak self] (value) in
                    guard let self = self else {return}
                    self.firstName = value
                    let _ = self.validationFirstName()
                }),
            
            lastNameTF.rx.text
                .skip(2)
                .subscribe(onNext: { [weak self] (value) in
                    guard let self = self else {return}
                    self.lastName = value
                    let _ = self.validationLastName()
                }),
            
            cityofBirthTF.rx.text
                .skip(2)
                .subscribe(onNext: { [weak self] (value) in
                    guard let self = self else {return}
                    self.cityofBirth = value
                    let _ = self.validationCityBirth()
                }),
            
            noKTPTF.rx.text
                .skip(2)
                .subscribe(onNext: { [weak self] (value) in
                    guard let self = self else {return}
                    self.noKTP = value
                    let _ = self.validationID()
                }),
        ])
        
    }
    
    func showRelationship(){
        //DATA SHOWN IN THIS LIST IS DUMMY
        GeneralPicker.open(from: self, title: "Pilih Jenis Hubungan Keluarga", type: .text, data: familyRelationList) { [weak self] (result, row) in
            guard let row = row else {return}
            guard let self = self else {return}
            self.relationTF.text = result as? String
            self.relationContainer.errorBorder(isError: false)
            self.relationErrorView.isHidden = true
            if let data = self.familyRelationData?.data[row].id{
                self.relation = data
            }
            
        }
    }
    
    func showGender(){
        GeneralPicker.open(from: self, title: "Pilih Jenis Kelamin", type: .text, data: ["Laki-laki","Perempuan"]) { [weak self] (result, row) in
            guard let row = row else {return}
            guard let self = self else {return}
            self.genderTF.text = result as? String
            self.genderContainer.errorBorder(isError: false)
            self.genderErrorView.isHidden = true
            self.gender = (result as? String) == "Laki-laki" ? "MALE" : "FEMALE"
        }
    }
    
    func showBirthday(){
        let date = Date()
        GeneralPicker.open(from: self, title: "Pilih Tanggal Lahir", type: .date(mode: .date, dateDefault: date), data: []) { [weak self] (result, row) in
            guard let res = result as? Date else {return}
            guard let self = self else {return}
            let dateFormatter = DateFormatter()
            
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let dateString = dateFormatter.string(from: res)
            self.dobTF.text = dateString

            self.dobContainer.errorBorder(isError: false)
            self.dobErrorView.isHidden = true
            
            dateFormatter.dateFormat = "yyyy-MM-dd"
            self.dob  = dateFormatter.string(from: res)
        }
    }
    
    
    func showPlceOfBirth(){
        //DATA SHOWN IN THIS LIST IS DUMMY
        GeneralPicker.open(from: self, title: "Pilih Tempat Lahir", type: .text, data: countryListString) { [weak self] (result, row) in
            guard let row = row else {return}
            guard let self = self else {return}
            self.placeOfBirthTF.text = result as? String
            self.placeOfBirthContainer.errorBorder(isError: false)
            self.placeOfBirthErrorView.isHidden = true

            if let data = self.countryData?.data[row].countryId{
                self.placeOfBirth = data
            }
        }
    }
    
    func showCitizenship(){
        //DATA SHOWN IN THIS LIST IS DUMMY
        GeneralPicker.open(from: self, title: "Pilih Kewarganegaraan", type: .text, data: countryListString) { [weak self] (result, row) in
            guard let row = row else {return}
            guard let self = self else {return}
            self.citizenshipTF.text = result as? String
            self.citizenshipContainer.errorBorder(isError: false)
            self.citizenshipErrorView.isHidden = true
            self.citizenship = result as? String
            
            if let data = self.countryData?.data[row].countryId{
                self.citizenship = data
            }
        }
    }
    
    @discardableResult
    private func validationID() -> Bool {
        guard let text = noKTPTF.text else { return false }
        
        if text.isEmpty {
            noKTPContainer.errorBorder(isError: true)
            noKTPErrorLabel.text = "Mohon kolom untuk diisi"
            noKTPErrorView.isHidden = false
            return false
        }
        
        if text.count < 10 || text.count > 20{
            noKTPContainer.errorBorder(isError: true)
            noKTPErrorLabel.text = "Minimal 10 karakter"
            noKTPErrorView.isHidden = false
            return false
        }
        
        noKTPContainer.errorBorder(isError: false)
        noKTPErrorLabel.text?.removeAll()
        noKTPErrorView.isHidden = true
        return true
    }
    
    private func validationRelation() -> Bool {
        guard let text = relationTF.text else { return false }
        
        if text.isEmpty{
            relationContainer.errorBorder(isError: true)
            relationErrorLabel.text = "Mohon kolom untuk diisi"
            relationErrorView.isHidden = false
            return false
        }
        
        if text.lowercased() == "pribadi" {
            relationContainer.errorBorder(isError: true)
            relationErrorLabel.text = "Tidak dapat menambahkan Pribadi lebih dari satu"
            relationErrorView.isHidden = false
            return false
        }
        
        relationContainer.errorBorder(isError: false)
        relationErrorLabel.text?.removeAll()
        relationErrorView.isHidden = true
        return true
    }
    
    private func validationFirstName() -> Bool {
        guard let text = firstNameTF.text else { return false }
        
        if text.isEmpty {
            firstNameContainer.errorBorder(isError: true)
            firstNameErrorLabel.text = "Mohon kolom untuk diisi"
            firstNameErrorView.isHidden = false
            return false
        }
        
        if text.count < 2 {
            firstNameContainer.errorBorder(isError: true)
            firstNameErrorLabel.text = "Minimal 2 karakter"
            firstNameErrorView.isHidden = false
            return false
        }
        
        firstNameContainer.errorBorder(isError: false)
        firstNameErrorLabel.text?.removeAll()
        firstNameErrorView.isHidden = true
        return true
    }
    
    private func validationLastName() -> Bool {
        guard let text = lastNameTF.text else { return false }
        
        if text.count < 2 && !text.isEmpty{
            lastNameContainer.errorBorder(isError: true)
            lastNameErrorLabel.text = "Minimal 2 karakter"
            lastNameErrorView.isHidden = false
            return false
        }
        
        lastNameContainer.errorBorder(isError: false)
        lastNameErrorLabel.text?.removeAll()
        lastNameErrorView.isHidden = true
        return true
    }
    
    private func validationGender() -> Bool {
        guard let text = genderTF.text else { return false }
        
        if text.isEmpty{
            genderContainer.errorBorder(isError: true)
            genderErrorLabel.text = "Mohon kolom untuk diisi"
            genderErrorView.isHidden = false
            return false
        }
        
        genderContainer.errorBorder(isError: false)
        genderErrorLabel.text?.removeAll()
        genderErrorView.isHidden = true
        return true
    }
    
    private func validationDOB() -> Bool {
        guard let text = dobTF.text else { return false }
        
        if text.isEmpty{
            dobContainer.errorBorder(isError: true)
            dobErrorLabel.text = "Mohon kolom untuk diisi"
            dobErrorView.isHidden = false
            return false
        }
        
        dobContainer.errorBorder(isError: false)
        dobErrorLabel.text?.removeAll()
        dobErrorView.isHidden = true
        return true
    }
    
    private func validationPOB() -> Bool {
        guard let text = placeOfBirthTF.text else { return false }
        
        if text.isEmpty{
            placeOfBirthContainer.errorBorder(isError: true)
            placeOfBirthErrorLabel.text = "Mohon kolom untuk diisi"
            placeOfBirthErrorView.isHidden = false
            return false
        }
        
        placeOfBirthContainer.errorBorder(isError: false)
        placeOfBirthErrorLabel.text?.removeAll()
        placeOfBirthErrorView.isHidden = true
        return true
    }
    
    private func validationCityBirth() -> Bool {
        guard let text = cityofBirthTF.text else { return false }
        
        if text.isEmpty{
            cityofBirthContainer.errorBorder(isError: true)
            placeOfBirthErrorLabel.text = "Mohon kolom untuk diisi"
            placeOfBirthErrorView.isHidden = false
            return false
        }
        
        cityofBirthContainer.errorBorder(isError: false)
        placeOfBirthErrorLabel.text?.removeAll()
        placeOfBirthErrorView.isHidden = true
        return true
    }
    
    private func validationCitizenship() -> Bool {
        guard let text = citizenshipTF.text else { return false }
        
        if text.isEmpty{
            citizenshipContainer.errorBorder(isError: true)
            citizenshipErrorLabel.text = "Mohon kolom untuk diisi"
            citizenshipErrorView.isHidden = false
            return false
        }
        
        citizenshipContainer.errorBorder(isError: false)
        citizenshipErrorLabel.text?.removeAll()
        citizenshipErrorView.isHidden = true
        return true
    }
    
    private func validationAddress() -> Bool {
        guard let text = addressTF.text else { return false }
        
        if text.isEmpty{
            addressContainer.errorBorder(isError: true)
            addressErrorLabel.text = "Mohon kolom untuk diisi"
            addressErrorView.isHidden = false
            return false
        }
        
        addressContainer.errorBorder(isError: false)
        addressErrorLabel.text?.removeAll()
        addressErrorView.isHidden = true
        return true
    }
    
    // MARK: - BUTTON ACTION
    
    private func continueTapped(){
        guard
            validationRelation() &&
                validationFirstName() &&
                validationLastName() &&
                validationGender() &&
                validationDOB() &&
                validationPOB() &&
                validationCityBirth() &&
                validationCitizenship() &&
                validationID() &&
                validationAddress() else { return }
        
        let vc = PreviewAddedFamVC(name: "\(firstName ?? "") \(lastName ?? "")", dob: dobTF.text ?? "", birth: placeOfBirthTF.text ?? "", citizenship: citizenshipTF.text ?? "", gender: genderTF.text ?? "")
        vc.delegate = self
        presentPanModal(vc)
    }
}


extension AddMemberVC: UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == genderTF {
            showGender()
            return false
        }else if textField == dobTF{
            showBirthday()
            return false
        }else if textField == relationTF{
            showRelationship()
            return false
        }else if textField == placeOfBirthTF{
            showPlceOfBirth()
            return false
        }else if textField == citizenshipTF{
            showCitizenship()
            return false
        }
        else if textField == addressTF{
            dismissKeyboard()
            chooseAddressTapped?()
            return false
        }
        return true
    }
}


extension AddMemberVC : ProfilePreviewDelegate, AddProfileAsAccountDelegate{
    func continueProcess(){
        presentPanModal(addAsAccount)
    }
    
    func registProfile(){
        registMemberTapped?(AddMemberBody(familyRelationType: self.relation,
                                          firstName: self.firstName,
                                          lastName: self.lastName,
                                          gender: self.gender,
                                          birthDate: self.dob,
                                          birthCountry: self.placeOfBirth,
                                          birthPlace: self.cityofBirth,
                                          nationality: self.citizenship,
                                          cardID: self.noKTP,
                                          addressID: self.address))
    }
    
    func denyRegist(){
        addMemberRequest.accept(AddMemberBody(familyRelationType: self.relation,
                                              firstName: self.firstName,
                                              lastName: self.lastName,
                                              gender: self.gender,
                                              birthDate: self.dob,
                                              birthCountry: self.placeOfBirth,
                                              birthPlace: self.cityofBirth,
                                              nationality: self.citizenship,
                                              cardID: self.noKTP,
                                              addressID: self.address))
        
        
    }
}
