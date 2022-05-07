//
//  AddAddressVC.swift
//  Altea Care
//
//  Created by Hedy on 11/08/21.
//

import UIKit
import RxSwift
import RxCocoa
import PanModal

class AddAddressVC: UIViewController, AddAddressView {
    var onSuccessAddAddress: (() -> Void)?
    var viewModel: AddAddressVM!
    
    @IBOutlet weak var tfAlamat: UITextField!
    @IBOutlet weak var tfCountry: UITextField!
    @IBOutlet weak var tfProvinsi: UITextField!
    @IBOutlet weak var tfCity: UITextField!
    @IBOutlet weak var tfKecamatan: UITextField!
    @IBOutlet weak var tfKelurahan: UITextField!
    @IBOutlet weak var tfRtRw: UITextField!
    
    @IBOutlet weak var exclamationAlamat: UIImageView!
    @IBOutlet weak var exclamationProvinsi: UIImageView!
    @IBOutlet weak var exclamationCountry: UIImageView!
    @IBOutlet weak var exclamationCity: UIImageView!
    @IBOutlet weak var exclamationKecamatan: UIImageView!
    @IBOutlet weak var exclamationKelurahan: UIImageView!
    @IBOutlet weak var exclamationRtRw: UIImageView!
    
    @IBOutlet weak var labelMessageRtRw: UILabel!
    @IBOutlet weak var labelMessageKelurahan: UILabel!
    @IBOutlet weak var labelMessageKecamatan: UILabel!
    @IBOutlet weak var labelMessageKota: UILabel!
    @IBOutlet weak var labelMessageProvinsi: UILabel!
    @IBOutlet weak var labelMessageCountry: UILabel!
    @IBOutlet weak var labelMessageAlamat: UILabel!
    
    @IBOutlet weak var viewAlertAddress: UIView!
    @IBOutlet weak var viewAlertCountry: UIView!
    @IBOutlet weak var viewAlertProvince: UIView!
    @IBOutlet weak var viewAlertCity: UIView!
    @IBOutlet weak var viewAlertDistrictKecamatan: UIView!
    @IBOutlet weak var viewAlertSubDistrictKecamatan: UIView!
    @IBOutlet weak var viewAlertRtRw: UIView!
    
    @IBOutlet weak var buttonSubmit: UIButton!
    private let disposeBag = DisposeBag()
    
    private let viewDidLoadRelay = PublishRelay<Void>()
    private let provinceRequest = BehaviorRelay<ProvinciesBody?>(value: nil)
    private let cityRequest = BehaviorRelay<CitiesBody?>(value: nil)
    private let districtRequest = BehaviorRelay<DistrictBody?>(value: nil)
    private let subDistrictRequest = BehaviorRelay<SubDistrictBody?>(value: nil)
    private let addAddressRequest = BehaviorRelay<AddAddressBody?>(value: nil)
    
    
    private var countryData : CountryModel? = nil{
        didSet{
            guard let data = countryData?.data else {return}
            countryListString = data.map {$0.name}
        }
    }
    
    private var proviceModel : ProvinceAddressModel? = nil{
        didSet{
            guard let data = proviceModel?.data else {return}
            provinceListString = data.map {$0.nameProvince}
        }
    }
    
    private var cityData : CityAddressModel? = nil{
        didSet{
            guard let data = cityData?.data else {return}
            cityListString = data.map {$0.nameCity}
        }
    }
    
    private var districtData : DistrictKecamatanModel? = nil{
        didSet{
            guard let data = districtData?.data else {return}
            districtListString = data.map {$0.nameDistrictKecamatan}
        }
    }
    
    private var subDistrictData : SubdistrictKelurahanModel? = nil{
        didSet{
            guard let data = subDistrictData?.data else {return}
            subDistrictListString = data.map {$0.nameSubdistrictKelurahan}
        }
    }
    
    private var countryListString = [String]()
    private var provinceListString = [String]()
    private var cityListString = [String]()
    private var districtListString = [String]()
    private var subDistrictListString = [String]()
    
    var countryIdSelected: String? = ""
    var provinceIdSelected: String? = ""
    var cityIdSelected: String? = ""
    var districtIdSelected: String? = ""
    var subDistrictIdSelected: String? = ""
    var street : String?
    var RtRw : String?
    
    var defaultCountry : String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModel()
        self.viewDidLoadRelay.accept(())
        self.setupNavigation()
        self.setupActiveButton(button: buttonSubmit)
        // Do any additional setup after loading the view.
    }
    
    func bindViewModel() {
        let input = AddAddressVM.Input(viewDidloadRelay: self.viewDidLoadRelay.asObservable(), provinceInput: self.provinceRequest.asObservable(), cityInput: self.cityRequest.asObservable(), districtInput: self.districtRequest.asObservable(), subDistrictInput: self.subDistrictRequest.asObservable(), addAddressInput: self.addAddressRequest.asObservable())
        let output = viewModel.transform(input)
        
        output.countryData.drive { (data) in
            self.countryData = data
            self.setupTfCountry()
        }.disposed(by: self.disposeBag)
        
        output.provinceOutput.drive { (data) in
            self.proviceModel = data
        }.disposed(by: self.disposeBag)
        
        output.cityOutput.drive { (data) in
            self.cityData = data
        }.disposed(by: self.disposeBag)
        
        output.districtOutput.drive { (data) in
            self.districtData = data
        }.disposed(by: self.disposeBag)
        
        output.subDistrictOutput.drive { (data) in
            self.subDistrictData = data
        }.disposed(by: self.disposeBag)
        output.addAddressOutput.drive { (data) in
//            if data?.status == true {
                self.onSuccessAddAddress?()
//            }
        }.disposed(by: self.disposeBag)
        
        self.setupUI()
        self.setupRx()
    }
    
    func setupNavigation (){
        self.setTextNavigation(title: "Tambah Alamat", navigator: .back)
    }
    
    func setupUI(){
        tfCity.addDropDownViewer()
        tfProvinsi.addDropDownViewer()
        tfKecamatan.addDropDownViewer()
        tfKelurahan.addDropDownViewer()
        tfCountry.addDropDownViewer()

        tfCountry.delegate = self
        tfCity.delegate = self
        tfProvinsi.delegate = self
        tfKecamatan.delegate = self
        tfKelurahan.delegate = self
    }
    
    private func setupTfCountry(){
        let dataDefaultCountry = self.countryData?.data.filter{
            $0.name.lowercased().contains("indonesia")
        }
        self.countryIdSelected = dataDefaultCountry?[0].countryId
        tfCountry.text = dataDefaultCountry?[0].name
        
        tfCountry.sendActions(for: .valueChanged)
        self.provinceRequest.accept(ProvinciesBody(id: self.countryIdSelected ?? ""))
    }
    
    private func setupRx(){
        disposeBag.insert([
            tfAlamat.rx.text
                .skip(2)
                .subscribe(onNext: { [weak self] (value) in
                    guard let self = self else {return}
                    self.tfAlamat.text = value
                    self.street = value
                }),
            
            tfCity.rx.text
                .skip(2)
                .subscribe(onNext: { [weak self] (value) in
                    guard let self = self else {return}
                    self.tfCity.text = value
                }),
            
            tfCountry.rx.text
                .skip(2)
                .subscribe(onNext: { [weak self] (value) in
                    guard let self = self else {return}
                    self.tfCountry.text = value
                }),
            
            tfKelurahan.rx.text
                .skip(2)
                .subscribe(onNext: { [weak self] (value) in
                    guard let self = self else {return}
                    self.tfKelurahan.text = value
                }),
            
            tfKecamatan.rx.text
                .skip(2)
                .subscribe(onNext: { [weak self] (value) in
                    guard let self = self else {return}
                    self.tfKecamatan.text = value
                }),
            
            tfRtRw.rx.text
                .skip(2)
                .subscribe(onNext: { [weak self] (value) in
                    guard let self = self else {return}
                    self.tfRtRw.text = value
                    self.RtRw = value
                }),
        ])
    }
    
    func showCountryList(){
        GeneralPicker.open(from: self, title: "Pilih Negara", type: .text, data: countryListString) { [weak self] (result, row) in
            guard let row = row else { return }
            guard let self = self else {return}
            self.tfCountry.text = result as? String
            
            if let idSelected = self.countryData?.data[row].countryId{
                self.countryIdSelected = idSelected
                
                self.provinceRequest.accept(ProvinciesBody(id: self.countryIdSelected ?? ""))
            }
        }
    }
    
    func showProvinsiList(){
        GeneralPicker.open(from: self, title: "Pilih Provinsi", type: .text,
                           data: provinceListString
        ) { [weak self] (result, row) in
            guard let row = row else { return }
            guard let self = self else {return}
            self.tfProvinsi.text = result as? String
            
            if let idSelected = self.proviceModel?.data[row].idProvince{
                self.provinceIdSelected = idSelected
                
                self.cityRequest.accept(CitiesBody(id: self.provinceIdSelected ?? ""))
            }
        }
    }
    
    func showCityList(){
        GeneralPicker.open(from: self, title: "Pilih Kota", type: .text,
                           data: cityListString
        ) { [weak self] (result, row) in
            guard let row = row else { return }
            guard let self = self else {return}
            self.tfCity.text = result as? String
            
            if let idSelected = self.cityData?.data[row].idCity{
                self.cityIdSelected = idSelected
                
                self.districtRequest.accept(DistrictBody(id: self.cityIdSelected ?? ""))
            }
        }
    }
    
    func showKecamatanList(){
        GeneralPicker.open(from: self, title: "Pilih Kecamatan", type: .text,
                           data: districtListString
        ) { [weak self] (result, row) in
            guard let row = row else { return }
            guard let self = self else {return}
            self.tfKecamatan.text = result as? String
            
            if let idSelected = self.districtData?.data[row].idKecamatan{
                self.districtIdSelected = idSelected
                
                self.subDistrictRequest.accept(SubDistrictBody(id: self.districtIdSelected ?? ""))
            }
        }
    }
    
    func showKelurahanList(){
        GeneralPicker.open(from: self, title: "Pilih Kelurahan", type: .text,
                           data: subDistrictListString
        ) { [weak self] (result, row) in
            guard let row = row else { return }
            guard let self = self else {return}
            self.tfKelurahan.text = result as? String
            
            if let idSelected = self.subDistrictData?.data[row].idKelurahan{
                self.subDistrictIdSelected = idSelected
            }
        }
    }
    
    @IBAction func submitTapped(_ sender: Any) {
        self.addAddressRequest.accept(AddAddressBody(street: self.street, country: self.countryIdSelected, province: self.provinceIdSelected, city: self.cityIdSelected, district: self.districtIdSelected, subDistrict: self.subDistrictIdSelected, rtRw: self.RtRw))
    }
}

extension AddAddressVC : UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == tfCountry {
            showCountryList()
            return false
        } else if textField == tfCity {
            showCityList()
            return false
        } else if textField == tfProvinsi {
            showProvinsiList()
            return false
        } else if textField == tfKelurahan {
            showKelurahanList()
            return false
        } else if textField == tfKecamatan {
            showKecamatanList()
            return false
        }
        return true
    }
}
