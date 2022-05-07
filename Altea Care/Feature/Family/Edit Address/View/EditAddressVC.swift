//
//  EditAddressVC.swift
//  Altea Care
//
//  Created by Hedy on 11/08/21.
//

import UIKit
import RxSwift
import RxCocoa

class EditAddressVC: UIViewController, EditAddressView, UITextFieldDelegate {
    var modelAddress: DetailAddressModel!
    
    var onSuccessEditAddress: (() -> Void)?
    var idAddress: String! {
        didSet{
            idRelay.accept(idAddress)
        }
    }
    var viewModel: EditAddressVM!
    
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var labelCountry: UILabel!
    @IBOutlet weak var labelProvince: UILabel!
    @IBOutlet weak var LabelCity: UILabel!
    @IBOutlet weak var labelDistrictKecamatan: UILabel!
    @IBOutlet weak var labelSubDistrictKecamatan: UILabel!
    @IBOutlet weak var labelRtRw: UILabel!
    
    @IBOutlet weak var tfAlamat: UITextField!
    @IBOutlet weak var tfCountry: UITextField!
    @IBOutlet weak var tfProvince: UITextField!
    @IBOutlet weak var tfCity: UITextField!
    @IBOutlet weak var tfDistrictKecamatan: UITextField!
    @IBOutlet weak var tfSubDistrictKelurahan: UITextField!
    @IBOutlet weak var tfRtRw: UITextField!
    
    @IBOutlet weak var alertViewSubDistrictKelurahan: UIView!
    @IBOutlet weak var alertViewRtRw: UIView!
    @IBOutlet weak var alertViewDistrictKecamatan: UIView!
    @IBOutlet weak var alertViewCity: UIView!
    @IBOutlet weak var alertViewProvince: UIView!
    @IBOutlet weak var alertViewCountry: UIView!
    @IBOutlet weak var alertViewAddress: UIView!
    
    @IBOutlet weak var labelMessageAddress: UILabel!
    @IBOutlet weak var labelMessageCountry: UILabel!
    @IBOutlet weak var labelMessageProvince: UILabel!
    @IBOutlet weak var labelMessageCity: UILabel!
    @IBOutlet weak var labelMessageDistrictKecamatan: UILabel!
    @IBOutlet weak var labelMessageSubDistrictKelurahan: UILabel!
    @IBOutlet weak var labelMessageRtRw: NSLayoutConstraint!
    
    private let disposeBag = DisposeBag()
    @IBOutlet weak var buttonSubmit: UIButton!
    
    private let getDetailRequest = BehaviorRelay<DetailAddressBody?>(value: nil)
    private let editAddressRequest = BehaviorRelay<EditAddressBody?>(value: nil)
    private let viewDidloadRelay = PublishRelay<Void>()
    
    private let provinceRequest = BehaviorRelay<ProvinciesBody?>(value: nil)
    private let cityRequest = BehaviorRelay<CitiesBody?>(value: nil)
    private let districtRequest = BehaviorRelay<DistrictBody?>(value: nil)
    private let subDistrictRequest = BehaviorRelay<SubDistrictBody?>(value: nil)
    
    private let idRelay = BehaviorRelay<String?>(value: nil)
    
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
    
    var countryIdSelected: String?
    var provinceIdSelected: String?
    var cityIdSelected: String?
    var districtIdSelected: String?
    var subDistrictIdSelected: String?
    var street : String?
    var RtRw : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        self.setupRx()
        self.setupNavigation()
        self.bindViewModel()
        self.viewDidloadRelay.accept(())
        self.setupActiveButton(button: buttonSubmit)
        self.getDetailRequest.accept(DetailAddressBody(id: idAddress))
        print("ini id address : \(self.idRelay.value)")
        // Do any additional setup after loading the view.
    }

    func bindViewModel() {
        let input = EditAddressVM.Input(id: self.idRelay.asObservable(), viewDidLoadRelay: self.viewDidloadRelay.asObservable(), detailInput: self.getDetailRequest.asObservable(), provinceInput: self.provinceRequest.asObservable(), cityInput: self.cityRequest.asObservable(), districtInput: self.districtRequest.asObservable(), subDistrictInput: self.subDistrictRequest.asObservable(), editAddressInput: editAddressRequest.asObservable())
        let output = viewModel.transform(input)
        output.state.drive(self.rx.state).disposed(by: self.disposeBag)
        
        output.countryData.drive { (data) in
            self.countryData = data
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
        
        output.detailOutput.drive { (data) in
            self.setupForm(data)
        }.disposed(by: self.disposeBag)
        
        output.updateAddress.drive { [weak self] (data) in
            self?.onSuccessEditAddress?()
        }.disposed(by: self.disposeBag)
    }
    
    func setupNavigation (){
        self.setTextNavigation(title: "Ubah Alamat", navigator: .back)
    }
    
    @IBAction func submitTapped(_ sender: Any) {
        self.editAddressRequest.accept(EditAddressBody(street: street ?? "", country: countryIdSelected ?? "", province: provinceIdSelected ?? "", city: cityIdSelected ?? "", district: districtIdSelected ?? "", sub_district: subDistrictIdSelected ?? "", rt_rw: RtRw ?? ""))
    }
    
    private func setupForm(_ model : DetailAddressModel?){
        guard let model = model else { return }
        tfAlamat.text =  model.street
        tfCountry.text = model.country
        tfProvince.text = model.province
        tfCity.text = model.city
        tfDistrictKecamatan.text = model.district
        tfSubDistrictKelurahan.text = model.subDistrict
        tfRtRw.text = model.rtRw
        
        street = model.street
        RtRw = model.rtRw
        countryIdSelected = model.idCountry
        provinceIdSelected = model.idProvince
        cityIdSelected = model.idCity
        districtIdSelected = model.idDistrict
        subDistrictIdSelected = model.idSubDistrict
        
        tfAlamat.sendActions(for: .valueChanged)
        tfCountry.sendActions(for: .valueChanged)
        tfProvince.sendActions(for: .valueChanged)
        tfCity.sendActions(for: .valueChanged)
        tfDistrictKecamatan.sendActions(for: .valueChanged)
        tfSubDistrictKelurahan.sendActions(for: .valueChanged)
        tfRtRw.sendActions(for: .valueChanged)
    }
    
    func setupUI(){
        tfCity.addDropDownViewer()
        tfProvince.addDropDownViewer()
        tfDistrictKecamatan.addDropDownViewer()
        tfSubDistrictKelurahan.addDropDownViewer()
        tfCountry.addDropDownViewer()

        tfCity.delegate = self
        tfProvince.delegate = self
        tfDistrictKecamatan.delegate = self
        tfSubDistrictKelurahan.delegate = self
        tfCountry.delegate = self
        tfRtRw.delegate = self
        tfAlamat.delegate = self
    }
    
    private func setupRx(){
        disposeBag.insert([
            tfAlamat.rx.text
                .skip(2)
                .subscribe(onNext: { [weak self] (value) in
                    guard let self = self else {return}
                    self.street = value
                })
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
//                           data:["Jawa Barat", "Jawa Timur","Jawa Tenggara","Jawa Tengah","Jawa Utara"]
        ) { [weak self] (result, row) in
            guard let row = row else { return }
            guard let self = self else {return}
            self.tfProvince.text = result as? String
            
            if let idSelected = self.proviceModel?.data[row].idProvince{
                self.provinceIdSelected = idSelected
                
                self.cityRequest.accept(CitiesBody(id: self.provinceIdSelected ?? ""))
            }
        }
    }
    
    func showCityList(){
        GeneralPicker.open(from: self, title: "Pilih Kota", type: .text,
                           data: cityListString
//                           data: ["Tangsel", "Ciputa","Indihiang","Bandung",""]
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
//                           data: ["Cihaur", "Cililitan","Cianjur","Banjarsari","Wakanda"]
        ) { [weak self] (result, row) in
            guard let row = row else { return }
            guard let self = self else {return}
            self.tfDistrictKecamatan.text = result as? String
            
            if let idSelected = self.districtData?.data[row].idKecamatan{
                self.districtIdSelected = idSelected
                
                self.subDistrictRequest.accept(SubDistrictBody(id: self.districtIdSelected ?? ""))
            }
        }
    }
    
    func showKelurahanList(){
        GeneralPicker.open(from: self, title: "Pilih Kelurahan", type: .text,
                           data: subDistrictListString
//                           data: ["Pondok Aren", "POndok Hijau","Pondok Orange","Pondokan"]
        ) { [weak self] (result, row) in
            guard let row = row else { return }
            guard let self = self else {return}
            self.tfSubDistrictKelurahan.text = result as? String
            
            if let idSelected = self.subDistrictData?.data[row].idKelurahan{
                self.subDistrictIdSelected = idSelected
            }
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == tfCountry {
            showCountryList()
            return false
        } else if textField == tfCity {
            showCityList()
            return false
        } else if textField == tfProvince {
            showProvinsiList()
            return false
        } else if textField == tfSubDistrictKelurahan {
            showKelurahanList()
            return false
        } else if textField == tfDistrictKecamatan {
            showKecamatanList()
            return false
        }
        return true
    }
}
