//
//  RegisterVC.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 10/03/21.
//

import UIKit
import RxSwift
import RxCocoa
import PanModal

class RegisterVC: UIViewController, RegisterView, UIPickerViewDelegate, UIPickerViewDataSource, GenderPickerDelegate{
    
    //MARK: - IBOutlets
    @IBOutlet weak var labelIndicator: UILabel!
    @IBOutlet weak var labelTItleFIllForm: UILabel!
    @IBOutlet weak var labelInstructionFillForm: UILabel!
    @IBOutlet weak var labelFirstname: UILabel!
    @IBOutlet weak var tfFirstname: UITextField!
    @IBOutlet weak var imageWarningFirstname: UIImageView!
    @IBOutlet weak var labelWarningFirstname: UILabel!
    
    @IBOutlet weak var labelLastname: UILabel!
    @IBOutlet weak var tfLastname: UITextField!
    @IBOutlet weak var imageWarningLastname: UIImageView!
    @IBOutlet weak var labelWarningLastname: UILabel!
    
    @IBOutlet weak var labelBirthdate: UILabel!
    @IBOutlet weak var tfBirthdate: UITextField!
    @IBOutlet weak var imageWarningBirthdate: UIImageView!
    @IBOutlet weak var labelWarningBirthdate: UILabel!
    
    @IBOutlet weak var labelGender: UILabel!
    @IBOutlet weak var tfGender: UITextField!{
        didSet {
            tfGender.setIcon(#imageLiteral(resourceName: "IconDownSelect"))
        }
    }
    @IBOutlet weak var imageWarningGender: UIImageView!
    @IBOutlet weak var labelWarningGender: UILabel!
    
    @IBOutlet weak var tfSelectCountry: UITextField! {
        didSet {
            tfSelectCountry.setIcon(#imageLiteral(resourceName: "IconDownSelect"))
        }
    }
    @IBOutlet weak var iconWarningSelectCountry: UIImageView!
    @IBOutlet weak var labelSelectCountryMessage: UILabel!
    
    @IBOutlet weak var tfSelectCity: UITextField!
    @IBOutlet weak var labelSelectCityMessage: UILabel!
    @IBOutlet weak var iconSelectCity: UIImageView!
    
    @IBOutlet weak var buttonSubmit: UIButton!
    
    private let disposeBag = DisposeBag()
    var onGenderPickerTapped: (() -> Void)?
    var goToNextRegisterStep: (() -> Void)?
    var viewModelRegister: RegisterVM!
    var genderSelected: String?
    var genderPass: String?
    var countryIdSelected: String? = ""
    private var countryData : CountryModel? = nil
    private var genderList = ["","Laki-laki", "Perempuan"]
    
    let pickerViewGender = UIPickerView()
    let pickerViewSelectCountry = UIPickerView()
    
    private let viewDidLoadRelay = PublishRelay<Void>()
    
    private lazy var genderPicker: GenderPickerVC = {
        let vc = GenderPickerVC()
        vc.delegate = self
        return vc
    }()
    
    //MARK: - View did load
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModel()
        self.setupHideKeyboardWhenTappedAround()
        self.setupActiveButton(button: buttonSubmit)
        self.setupNavigation()
        self.viewDidLoadRelay.accept(())
        tfSelectCountry.text = "Indonesia"
        tfBirthdate.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func bindViewModel(){
        let input = RegisterVM.Input(viewDidLoadRelay: self.viewDidLoadRelay.asObservable())
        let output =  viewModelRegister.transform(input)
        output.state.drive(self.rx.state).disposed(by: self.disposeBag)
        output.countryData.drive { (data) in
            self.countryData = data
            let dataCountry = self.countryData?.data.filter {$0.name.lowercased().contains("indonesia")}
            self.countryIdSelected = dataCountry?[0].countryId
            UserDefaults.standard.set(self.countryIdSelected, forKey: "countryId")
        }.disposed(by: self.disposeBag)
        
        self.createPickerView()
    }
    
    func maleSelected() {
        tfGender.text = "\(genderPicker.genderItems[0])"
    }
    
    func femaleSelected() {
        tfGender.text = "\(genderPicker.genderItems[1])"
    }
    
    //MARK: - Setup Picker for Gender
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pickerViewSelectCountry {
            return countryData?.data.count ?? 0
        }
//        if pickerView ==  pickerViewGender {
            return genderList.count
//        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pickerViewSelectCountry {
            return countryData?.data[row].name
        }
        return genderList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pickerViewGender {
            genderSelected = genderList[row]
            if row == 1 {
                genderPass = "MALE"
            }
            if row == 2 {
                genderPass = "FEMALE"
            }
            
            tfGender.text = genderSelected
        }
        
        if pickerView == pickerViewSelectCountry {
            countryIdSelected = countryData?.data[row].countryId
            tfSelectCountry.text = countryData?.data[row].name
            UserDefaults.standard.set(countryIdSelected, forKey: "countryId")
        }
    }
    
    func createPickerView(){
        pickerViewGender.delegate = self
        tfGender.inputView = pickerViewGender
        
        pickerViewSelectCountry.delegate = self
        tfSelectCountry.inputView = pickerViewSelectCountry
    }
    
    func dismissPickerView(){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let button =  UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.action))
        toolbar.setItems([button], animated: true)
        toolbar.isUserInteractionEnabled = true
        tfGender.inputAccessoryView = toolbar
    }
    
    @objc func action(){
        view.endEditing(true)
    }
    
    //MARK: -Setup Navigation
    private func setupNavigation(){
        self.setTextNavigation(title: "Daftar", navigator: .back)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layer.masksToBounds = false
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.lightGray.cgColor
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.8
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 2
    }
    
    //MARK: -Setup Date Picker
    
    func showBirthday(){
        let date = Date()
        GeneralPicker.open(from: self, title: "Pilih Tanggal Lahir", type: .date(mode: .date, dateDefault: date), data: []) { [weak self] (result, row) in
            guard let res = result as? Date else {return}
            guard let self = self else {return}
            let dateFormatter = DateFormatter()
            
            dateFormatter.dateFormat = "dd MMM yyyy"
            let dateString = dateFormatter.string(from: res)
            self.tfBirthdate.text = dateString
            self.imageWarningBirthdate.isHidden = true
            self.labelWarningBirthdate.isHidden = true
            self.tfBirthdate.sendActions(for: .valueChanged)

            dateFormatter.dateFormat = "yyyy-MM-dd"
            self.tfBirthdate.text  = dateFormatter.string(from: res)
            let dateApi = dateFormatter.string(from: res)
            UserDefaults.standard.set(dateApi, forKey: "Date")
        }
    }
    
    //MARK: - Validation form
    @IBAction func validFirstName(_ sender: Any) {
        UserDefaults.standard.set(tfFirstname.text, forKey: "firstname")
        imageWarningFirstname.isHidden = true
        labelWarningFirstname.isHidden = true
    }
    
    @IBAction func validLastname(_ sender: Any) {
        UserDefaults.standard.set(tfLastname.text, forKey: "lastname")
        imageWarningLastname.isHidden = true
        labelWarningLastname.isHidden = true
    }
    
    
    @IBAction func validBirthCity(_ sender: Any) {
        if tfSelectCity.hasText {
            iconSelectCity.isHidden = true
            labelSelectCityMessage.isHidden = true
        }
    }
    
    @IBAction func validGender(_ sender: Any) {
        imageWarningGender.isHidden = true
        labelWarningGender.isHidden = true
    }
    
    @IBAction func validCountry(_ sender: Any) {
//        if tfSelectCountry.hasText {
            iconWarningSelectCountry.isHidden = true
            labelSelectCountryMessage.isHidden = true
//        }
    }
    //MARK: - Button tapped
    @IBAction func buttonTapped(_ sender: Any) {
        let firsname = tfFirstname.text ?? ""
        let lastname = tfLastname.text ?? ""
        let date = tfBirthdate.text ?? ""
        let gender = tfGender.text ?? ""
        let country =  tfSelectCountry.text ?? ""
        let city = tfSelectCity.text ?? ""
        
        UserDefaults.standard.set(country, forKey: "country")
        UserDefaults.standard.set(city, forKey: "city")
        
        if city.isEmpty {
            iconSelectCity.isHidden = false
            labelSelectCityMessage.isHidden = false
        }
        
        if country.isEmpty {
            iconWarningSelectCountry.isHidden = false
            labelSelectCountryMessage.isHidden = false
        }
        
        if firsname.isEmpty {
            imageWarningFirstname.isHidden = false
            labelWarningFirstname.isHidden = false
        }
        if lastname.isEmpty {
            imageWarningLastname.isHidden = false
            labelWarningLastname.isHidden = false
        }
        if date.isEmpty {
            imageWarningBirthdate.isHidden = false
            labelWarningBirthdate.isHidden = false
        }
        if gender.isEmpty {
            imageWarningGender.isHidden = false
            labelWarningGender.isHidden = false
        }
        
        if firsname.isEmpty == false && lastname.isEmpty == false && date.isEmpty == false && gender.isEmpty == false && city.isEmpty == false && country.isEmpty == false{
            UserDefaults.standard.set(genderPass, forKey: "gender")
            self.goToNextRegisterStep?()
        }
    }
    
    @objc
    func cancelAction() {
        self.tfBirthdate.resignFirstResponder()
    }

    @objc
    func doneAction() {
        if let datePickerView = self.tfBirthdate.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM yyyy"
            dateFormatter.locale = Locale(identifier: "id_ID")
            let dateString = dateFormatter.string(from: datePickerView.date)
            self.tfBirthdate.text = dateString
            imageWarningBirthdate.isHidden = true
            labelWarningBirthdate.isHidden = true
            
            let dateFormatterForApi = DateFormatter()
            dateFormatterForApi.dateFormat = "yyyy-MM-dd"
            dateFormatterForApi.locale = Locale(identifier: "id_ID")
            let dateApi = dateFormatterForApi.string(from: datePickerView.date)
            UserDefaults.standard.set(dateApi, forKey: "Date")
            
            self.tfBirthdate.resignFirstResponder()
        }
    }
}

extension RegisterVC: UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == tfBirthdate {
            showBirthday()
            return false
        }
        return true
    }
}
