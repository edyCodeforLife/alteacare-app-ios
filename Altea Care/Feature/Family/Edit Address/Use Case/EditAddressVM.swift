//
//  EditAddressVM.swift
//  Altea Care
//
//  Created by Hedy on 11/08/21.
//

import Foundation
import RxSwift
import RxCocoa

class EditAddressVM: BaseViewModel {
    
    private let repository: EditAddressRepository
    private let disposeBag = DisposeBag()
    private let stateRelay = BehaviorRelay<BasicUIState>(value: .loading)
    private let detailAddressRelay = BehaviorRelay<DetailAddressModel?>(value: nil)
    private let countryRelay = BehaviorRelay<CountryModel?>(value: nil)
    private let provinceRelay = BehaviorRelay<ProvinceAddressModel?>(value: nil)
    private let cityRelay = BehaviorRelay<CityAddressModel?>(value: nil)
    private let districtRelay = BehaviorRelay<DistrictKecamatanModel?>(value: nil)
    private let subDistrictRelay = BehaviorRelay<SubdistrictKelurahanModel?>(value: nil)
    private let editAddressRelay = BehaviorRelay<Bool?>(value: nil)
    
    private let idRelay = BehaviorRelay<String?>(value: nil)
    
    struct Input {
        let id : Observable<String?>
        let viewDidLoadRelay : Observable<Void>
        let detailInput : Observable<DetailAddressBody?>
        let provinceInput : Observable<ProvinciesBody?>
        let cityInput : Observable<CitiesBody?>
        let districtInput : Observable<DistrictBody?>
        let subDistrictInput : Observable<SubDistrictBody?>
        let editAddressInput : Observable<EditAddressBody?>
    }
    
    struct Output {
        let state: Driver<BasicUIState>
        let detailOutput : Driver<DetailAddressModel?>
        let countryData : Driver<CountryModel?>
        let provinceOutput : Driver<ProvinceAddressModel?>
        let cityOutput : Driver<CityAddressModel?>
        let districtOutput : Driver<DistrictKecamatanModel?>
        let subDistrictOutput : Driver<SubdistrictKelurahanModel?>
        let updateAddress: Driver<Bool?>
    }
    
    init(repository: EditAddressRepository) {
        self.repository = repository
    }
    
    func transform(_ input: Input) -> Output {
        self.makeRequestDetail(input)
        self.makeRequestCountryList(input)
        self.makeRequestGetProvince(input)
        self.makeRequestGetCity(input)
        self.makeRequestGetDistrict(input)
        self.makeRequestGetSubDistrict(input)
        self.makeRequestEdit(input)
        self.makeIdDetail(input)
        return Output(state: self.stateRelay.asDriver().skip(1), detailOutput: self.detailAddressRelay.asDriver().skip(1), countryData: self.countryRelay.asDriver().skip(1), provinceOutput: self.provinceRelay.asDriver().skip(1), cityOutput: self.cityRelay.asDriver().skip(1), districtOutput: self.districtRelay.asDriver().skip(1), subDistrictOutput: self.subDistrictRelay.asDriver().skip(1), updateAddress: self.editAddressRelay.asDriver().skip(1))
    }
    
    private func requestDetail(body: DetailAddressBody) {
        self.repository
            .requestDetail(body: body)
            .subscribe { model in
                self.detailAddressRelay.accept(model)
                self.stateRelay.accept(.close)
            } onFailure: { error in
                self.stateRelay.accept(.warning(error.readableError))
            }.disposed(by: self.disposeBag)
    }
    
    private func makeRequestDetail(_ input : Input) {
        input
            .detailInput
            .compactMap { $0 }
            .subscribe(onNext: { (body) in
                self.requestDetail(body: body)
                self.stateRelay.accept(.loading)
            }, onError: { (error) in
                self.stateRelay.accept(.failure(error.readableError))
            }, onCompleted: {
                
            }).disposed(by: self.disposeBag)
    }
    
    func makeRequestEdit(_ input : Input){
        input
            .editAddressInput
            .compactMap { $0 }
            .subscribe(onNext: { (body) in
                print("id nya mana : \(self.idRelay.value)")
                self.requestEdit(id: self.idRelay.value ?? "", body: body)
                self.stateRelay.accept(.loading)
            }, onError: { (error) in
                self.stateRelay.accept(.failure(error.readableError))
            }).disposed(by: self.disposeBag)
    }
    
    private func makeIdDetail(_ input : Input){
        input
            .id
            .compactMap { $0 }
            .subscribe { (value) in
                self.idRelay.accept(value.element)
                self.stateRelay.accept(.loading)
            }.disposed(by: self.disposeBag)
    }
    
    
    private func requestEdit(id: String, body: EditAddressBody) {
        self.repository
            .requestEdit(id: id, body: body)
            .subscribe { model in
                self.stateRelay.accept(.success("Berhasil"))
                self.editAddressRelay.accept(true)
            } onFailure: { error in
                self.stateRelay.accept(.warning(error.readableError))
            }.disposed(by: self.disposeBag)
    }
    
    func requestGetCountry(){
        self.repository
            .requestGetCountry()
            .subscribe(onSuccess: { (result) in
                self.stateRelay.accept(.close)
                self.countryRelay.accept(result)
            }, onFailure: { (error) in
                self.stateRelay.accept(.failure(error.readableError))
            }).disposed(by: self.disposeBag)
    }
    
    
    private func makeRequestCountryList(_ input: Input) {
        input
            .viewDidLoadRelay
            .subscribe { (_) in
                self.stateRelay.accept(.loading)
                self.requestGetCountry()
            }.disposed(by: self.disposeBag)
    }
    
    private func makeRequestGetProvince(_ input : Input) {
        input
            .provinceInput
            .compactMap { $0 }
            .subscribe(onNext: { (body) in
                self.requestGetProvince(body: body)
                self.stateRelay.accept(.loading)
            }, onError: { (error) in
                self.stateRelay.accept(.failure(error.readableError))
            }, onCompleted: {
                
            }).disposed(by: self.disposeBag)
    }
    
    func requestGetProvince(body: ProvinciesBody){
        self.repository
            .requestGetProvince(body: body)
            .subscribe { (result) in
                self.provinceRelay.accept(result)
                self.stateRelay.accept(.close)
            } onFailure: { (error) in
                self.stateRelay.accept(
                    .failure(error.readableError))
            }.disposed(by: self.disposeBag)
    }
    
    private func makeRequestGetCity(_ input : Input) {
        input
            .cityInput
            .compactMap { $0 }
            .subscribe(onNext: { (body) in
                self.requestGetCity(body: body)
                self.stateRelay.accept(.loading)
            }, onError: { (error) in
                self.stateRelay.accept(.failure(error.readableError))
            }, onCompleted: {
                
            }).disposed(by: self.disposeBag)
    }
    
    func requestGetCity(body: CitiesBody){
        self.repository
            .requestGetCity(body: body)
            .subscribe { (result) in
                self.cityRelay.accept(result)
                self.stateRelay.accept(.close)
            } onFailure: { (error) in
                self.stateRelay.accept(
                    .failure(error.readableError))
            }.disposed(by: self.disposeBag)
    }
    
    private func makeRequestGetDistrict(_ input : Input) {
        input
            .districtInput
            .compactMap { $0 }
            .subscribe(onNext: { (body) in
                self.requestGetDistrict(body: body)
                self.stateRelay.accept(.loading)
            }, onError: { (error) in
                self.stateRelay.accept(.failure(error.readableError))
            }, onCompleted: {
                
            }).disposed(by: self.disposeBag)
    }
    
    func requestGetDistrict(body: DistrictBody){
        self.repository
            .requestGetDistrictKecamatan(body: body)
            .subscribe { (result) in
                self.districtRelay.accept(result)
                self.stateRelay.accept(.close)
            } onFailure: { (error) in
                self.stateRelay.accept(
                    .failure(error.readableError))
            }.disposed(by: self.disposeBag)
    }
    
    private func makeRequestGetSubDistrict(_ input : Input) {
        input
            .subDistrictInput
            .compactMap { $0 }
            .subscribe(onNext: { (body) in
                self.requestGetSubDistrict(body: body)
                self.stateRelay.accept(.loading)
            }, onError: { (error) in
                self.stateRelay.accept(.failure(error.readableError))
            }, onCompleted: {
                
            }).disposed(by: self.disposeBag)
    }
    
    func requestGetSubDistrict(body: SubDistrictBody){
        self.repository
            .requestGetSubDistrictKecamatan(body: body)
            .subscribe { (result) in
                self.subDistrictRelay.accept(result)
                self.stateRelay.accept(.close)
            } onFailure: { (error) in
                self.stateRelay.accept(
                    .failure(error.readableError))
            }.disposed(by: self.disposeBag)
    }
}
