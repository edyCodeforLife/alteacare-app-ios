//
//  AddAddressRepositoryImpl.swift
//  Altea Care
//
//  Created by Hedy on 11/08/21.
//

import Foundation
import RxSwift

class AddAddressRepositoryImpl: AddAddressRepository {
    
    private let addAddressAPI: AddAddressAPI
    private let countryAPI : CountryAPI
    private let provinceAPI : ProvinciesAPI
    private let cityAPI : CitiesAPI
    private let districtAPI : DistrictAPI
    private let subdistrictAPI : SubDistrictAPI
    private let disposeBag = DisposeBag()
    
    init(addAddressAPI: AddAddressAPI, countryAPI : CountryAPI, provinceAPI : ProvinciesAPI, cityAPI : CitiesAPI, districtAPI : DistrictAPI, subdistrictAPI : SubDistrictAPI) {
        self.countryAPI = countryAPI
        self.provinceAPI = provinceAPI
        self.cityAPI = cityAPI
        self.districtAPI = districtAPI
        self.subdistrictAPI = subdistrictAPI
        self.addAddressAPI = addAddressAPI
    }
    
    func requestAdd(body: AddAddressBody) -> Single<AddAddressModel> {
        return Single.create { (observer) in
            self.addAddressAPI
                .request(body: body)
                .catch { (error) -> PrimitiveSequence<SingleTrait, AddAddressResponse> in
                    if (error as? HTTPError) == HTTPError.expired {
                        return self
                            .addAddressAPI
                            .httpClient
                            .verify()
                            .andThen(self.addAddressAPI.request(body: body))
                    }
                    return Single.error(error)
                }
                .map { self.outputTransformModel($0) }
                .subscribe(onSuccess: { (result) in
                    switch result {
                    case .success(let model):
                        observer(.success(model))
                    case .failure(let error):
                        observer(.failure(error))
                    }
                }, onFailure: { (error) in
                    observer(.failure(error))
                })
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    private func outputTransformModel(_ response: AddAddressResponse) -> Result<AddAddressModel, HTTPError> {
        //MARK: - FIXME
        if response.status ?? false {
            let data = AddAddressModel(version: response.version ?? "", status: response.status ?? false, message: response.message ?? "", data: "")
            
            return .success(data)
        }
        return .failure(HTTPError.custom(response.message ?? ""))
    }
    
    func requestGetCountry() -> Single<CountryModel?> {
        return Single.create { (observer) in
            self.countryAPI
                .request()
                .catch{ (error) -> PrimitiveSequence<SingleTrait, CountryResponse> in
                    if (error as? HTTPError) == HTTPError.expired {
                        return self
                            .countryAPI
                            .httpClient
                            .verify()
                            .andThen(self.countryAPI.request())
                    }
                    return Single.error(error)
                }
                .map{ self.transformOutputCountryModel($0) }
                .subscribe(onSuccess: { (result) in
                    switch result {
                    case .success(let model) :
                        observer(.success(model))
                    case .failure(let error):
                        observer(.failure(error))
                    }
                }, onFailure: { (error) in
                    observer(.failure(error))
                }).disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    private func transformOutputCountryModel(_ response : CountryResponse) -> Result<CountryModel, HTTPError> {
        if response.status {
            let dataCountry = response.data.map { (data) in
                
                return CountryData(countryId: data.countryId, name: data.name)
            }
            
            let model =  CountryModel(status: response.status, message: response.message, data: dataCountry)
            return .success(model)
        }
        return .failure(HTTPError.custom(response.message))
    }
    
    func requestGetProvince(body: ProvinciesBody) -> Single<ProvinceAddressModel?> {
        return Single.create { (observer) in
            self.provinceAPI
                .requestProvincies(body: body)
                .catch{ (error) -> PrimitiveSequence<SingleTrait, ProvinciesResponse> in
                    if (error as? HTTPError) == HTTPError.expired {
                        return self
                            .provinceAPI
                            .httpClient
                            .verify()
                            .andThen(self.provinceAPI.requestProvincies(body: body))
                    }
                    return Single.error(error)
                }
                .map{ self.outputTransformProviceModel($0) }
                .subscribe(onSuccess: { (result) in
                    switch result {
                    case .success(let model) :
                        observer(.success(model))
                    case .failure(let error):
                        observer(.failure(error))
                    }
                }, onFailure: { (error) in
                    observer(.failure(error))
                }).disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    private func outputTransformProviceModel(_ response : ProvinciesResponse) -> Result<ProvinceAddressModel, HTTPError> {
        if response.status ?? false {
            let dataProvince = response.data.map { (data) in
                return ProvinceAddressModeldata(nameProvince: data.name ?? "", idProvince: data.provinceId ?? "")
            }
            
            let model = ProvinceAddressModel(status: response.status ?? false, message: response.message ?? "", data: dataProvince)
            return .success(model)
        }
        return .failure(HTTPError.custom(response.message ?? ""))
    }
    
    func requestGetCity(body: CitiesBody) -> Single<CityAddressModel?> {
        return Single.create { (observer) in
            self.cityAPI
                .requestCities(body: body)
                .catch{ (error) -> PrimitiveSequence<SingleTrait, CitiesResponse> in
                    if (error as? HTTPError) == HTTPError.expired {
                        return self
                            .cityAPI
                            .httpClient
                            .verify()
                            .andThen(self.cityAPI.requestCities(body: body))
                    }
                    return Single.error(error)
                }
                .map{ self.outputTransformCityModel($0) }
                .subscribe(onSuccess: { (result) in
                    switch result {
                    case .success(let model) :
                        observer(.success(model))
                    case .failure(let error):
                        observer(.failure(error))
                    }
                }, onFailure: { (error) in
                    observer(.failure(error))
                }).disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    private func outputTransformCityModel(_ response : CitiesResponse) -> Result<CityAddressModel, HTTPError> {
        if response.status ?? false {
            let dataCity = response.data.map { (data) in
                return CityAddressModelData(nameCity: data.name ?? "", idCity: data.cityId ?? "")
            }
            
            let model = CityAddressModel(status: response.status ?? false, message: response.message ?? "", data: dataCity)
            return .success(model)
        }
        return .failure(HTTPError.custom(response.message ?? ""))
    }
    
    func requestGetDistrictKecamatan(body: DistrictBody) -> Single<DistrictKecamatanModel?> {
        return Single.create { (observer) in
            self.districtAPI
                .requestDistrict(body: body)
                .catch{ (error) -> PrimitiveSequence<SingleTrait, DistrictResponse> in
                    if (error as? HTTPError) == HTTPError.expired {
                        return self
                            .districtAPI
                            .httpClient
                            .verify()
                            .andThen(self.districtAPI.requestDistrict(body: body))
                    }
                    return Single.error(error)
                }
                .map{ self.outputTransformDistrictKecamatanModel($0) }
                .subscribe(onSuccess: { (result) in
                    switch result {
                    case .success(let model) :
                        observer(.success(model))
                    case .failure(let error):
                        observer(.failure(error))
                    }
                }, onFailure: { (error) in
                    observer(.failure(error))
                }).disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    private func outputTransformDistrictKecamatanModel(_ response : DistrictResponse) -> Result<DistrictKecamatanModel, HTTPError> {
        
        if response.status ?? false {
            let dataDistrict = response.data.map { (data) in
                return DistrictKecamatanModelData(nameDistrictKecamatan: data.name ?? "", idKecamatan: data.districtId ?? "")
            }
            
            let model = DistrictKecamatanModel(status: response.status ?? false, message: response.message ?? "", data: dataDistrict)
            return .success(model)
        }
        return .failure(HTTPError.custom(response.message ?? ""))
    }
    
    func requestGetSubDistrictKecamatan(body: SubDistrictBody) -> Single<SubdistrictKelurahanModel?> {
        return Single.create { (observer) in
            self.subdistrictAPI
                .requestSubDistrict(body: body)
                .catch{ (error) -> PrimitiveSequence<SingleTrait, SubDistrictResponse> in
                    if (error as? HTTPError) == HTTPError.expired {
                        return self
                            .subdistrictAPI
                            .httpClient
                            .verify()
                            .andThen(self.subdistrictAPI.requestSubDistrict(body: body))
                    }
                    return Single.error(error)
                }
                .map{ self.outputTransformSubDistrictKelurahanModel($0) }
                .subscribe(onSuccess: { (result) in
                    switch result {
                    case .success(let model) :
                        observer(.success(model))
                    case .failure(let error):
                        observer(.failure(error))
                    }
                }, onFailure: { (error) in
                    observer(.failure(error))
                }).disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    private func outputTransformSubDistrictKelurahanModel(_ response : SubDistrictResponse) -> Result<SubdistrictKelurahanModel, HTTPError> {
        
        if response.status ?? false {
            let dataSubDistrict = response.data.map { (data) in
                return SubdistrictKelurahanModelData(nameSubdistrictKelurahan: data.name ?? "", idKelurahan: data.subDistrictId ?? "")
            }
            
            let model = SubdistrictKelurahanModel(status: response.status ?? false, message: response.message ?? "", data: dataSubDistrict)
            return .success(model)
        }
        return .failure(HTTPError.custom(response.message ?? ""))
    }
}
