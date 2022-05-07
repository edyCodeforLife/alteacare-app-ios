//
//  AddAddressVM.swift
//  Altea Care
//
//  Created by Hedy on 11/08/21.
//

import Foundation
import RxSwift
import RxCocoa

class AddAddressVM: BaseViewModel {
    
    private let repository: AddAddressRepository
    private let disposeBag = DisposeBag()
    private let stateRelay = BehaviorRelay<BasicUIState>(value: .loading)
    private let countryRelay = BehaviorRelay<CountryModel?>(value: nil)
    private let provinceRelay = BehaviorRelay<ProvinceAddressModel?>(value: nil)
    private let cityRelay = BehaviorRelay<CityAddressModel?>(value: nil)
    private let districtRelay = BehaviorRelay<DistrictKecamatanModel?>(value: nil)
    private let subDistrictRelay = BehaviorRelay<SubdistrictKelurahanModel?>(value: nil)
    private let addAddressRelay = BehaviorRelay<AddAddressModel?>(value: nil)
    
    struct Input {
        let viewDidloadRelay : Observable<Void>
        let provinceInput : Observable<ProvinciesBody?>
        let cityInput : Observable<CitiesBody?>
        let districtInput : Observable<DistrictBody?>
        let subDistrictInput : Observable<SubDistrictBody?>
        let addAddressInput : Observable<AddAddressBody?>
    }
    
    struct Output {
        let state: Driver<BasicUIState>
        let countryData : Driver<CountryModel?>
        let provinceOutput : Driver<ProvinceAddressModel?>
        let cityOutput : Driver<CityAddressModel?>
        let districtOutput : Driver<DistrictKecamatanModel?>
        let subDistrictOutput : Driver<SubdistrictKelurahanModel?>
        let addAddressOutput : Driver<AddAddressModel?>
    }
    
    init(repository: AddAddressRepository) {
        self.repository = repository
    }
    
    func transform(_ input: Input) -> Output {
        self.makeRequestCountryList(input)
        self.makeRequestGetProvince(input)
        self.makeRequestGetCity(input)
        self.makeRequestGetDistrict(input)
        self.makeRequestGetSubDistrict(input)
        self.makeRequestAddAddress(input)
        return Output(state: self.stateRelay.asDriver().skip(1), countryData: self.countryRelay.asDriver().skip(1), provinceOutput: self.provinceRelay.asDriver().skip(1), cityOutput: self.cityRelay.asDriver().skip(1), districtOutput: self.districtRelay.asDriver().skip(1), subDistrictOutput: self.subDistrictRelay.asDriver().skip(1), addAddressOutput: self.addAddressRelay.asDriver().skip(1))
    }
    
    private func requestAdd(body: AddAddressBody) {
        self.repository
            .requestAdd(body: body)
            .subscribe { model in
                self.addAddressRelay.accept(model)
                self.stateRelay.accept(.close)
            } onFailure: { (error) in
                self.stateRelay.accept(.failure(error.readableError))
            }.disposed(by: self.disposeBag)
    }
    
    private func makeRequestAddAddress(_ input : Input){
        input
            .addAddressInput
            .compactMap { $0 }
            .subscribe (onNext: { (body) in
                self.requestAdd(body: body)
                self.stateRelay.accept(.loading)
            }, onError: { (error) in
                self.stateRelay.accept(.failure(error.readableError))
            }, onCompleted: {
                
            }).disposed(by: self.disposeBag)
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
            .viewDidloadRelay
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
