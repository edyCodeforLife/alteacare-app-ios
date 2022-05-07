//
//  EditMemberRepositoryImpl.swift
//  Altea Care
//
//  Created by Hedy on 11/08/21.
//

import Foundation
import RxSwift

class EditMemberRepositoryImpl: EditMemberRepository {
    
    private let detailMemberAPI: DetailMemberAPI
    private let updateMemberAPI: UpdateMemberAPI
    private let countryAPI : CountryAPI
    private let familyRelationAPI : FamilyRelationAPI
    private let disposeBag = DisposeBag()
    
    init(detailMemberAPI: DetailMemberAPI, updateMemberAPI: UpdateMemberAPI, countryAPI : CountryAPI, familyRelationAPI: FamilyRelationAPI) {
        self.detailMemberAPI = detailMemberAPI
        self.updateMemberAPI = updateMemberAPI
        self.countryAPI = countryAPI
        self.familyRelationAPI = familyRelationAPI
    }
    
    func requestDetail(body: DetailMemberBody) -> Single<EditMemberModel> {
        return Single.create { (observer) in
            self.detailMemberAPI
                .request(body: body)
                .catch { (error) -> PrimitiveSequence<SingleTrait, DetailMemberResponse> in
                    if (error as? HTTPError) == HTTPError.expired {
                        return self
                            .detailMemberAPI
                            .httpClient
                            .verify()
                            .andThen(self.detailMemberAPI.request(body: body))
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
    
    private func outputTransformModel(_ response: DetailMemberResponse) -> Result<EditMemberModel, HTTPError> {
        //MARK: - FIXME
        if response.status {
            let data = response.data
            let model = EditMemberModel(cardId: data?.cardId ?? "",
                                        birthDate: data?.birthDate ?? "",
                                        firstName: data?.firstName ?? "",
                                        id: data?.id ?? "",
                                        gender: data?.gender ?? "",
                                        addressId: data?.addressId ?? "",
                                        lastName: data?.lastName ?? "",
                                        birthPlace: data?.birthPlace ?? "",
                                        city: data?.city ?? City(id: "", name: ""),
                                        district: data?.district ?? City(id: "", name: ""),
                                        country: data?.country ?? BirthCountry(id: "", code: "", name: ""),
                                        subDistrict: data?.subDistrict ?? SubDistrict(id: "", name: "", geoArea: "", postalCode: ""),
                                        street: data?.street ?? "",
                                        rtRw: data?.rtRw ?? "",
                                        cardType: data?.cardType ?? "",
                                        familyRelationType: data?.familyRelationType ?? City(id: "", name: ""),
                                        birthCountry: data?.birthCountry ?? BirthCountry(id: "", code: "", name: ""),
                                        nationality: data?.nationality ?? BirthCountry(id: "", code: "", name: ""),
                                        status: data?.status ?? "",
                                        isDefault: data?.isDefault ?? false)
            return .success(model)
        }
        return .failure(HTTPError.custom(response.message))
    }
    
    func requestUpdate(id: String, body: UpdateMemberBody) -> Single<Bool> {
        return Single.create { (observer) in
            self.updateMemberAPI
                .request(id: id, body: body)
                .catch { (error) -> PrimitiveSequence<SingleTrait, UpdateMemberResponse> in
                    if (error as? HTTPError) == HTTPError.expired {
                        return self
                            .updateMemberAPI
                            .httpClient
                            .verify()
                            .andThen(self.updateMemberAPI.request(id: id, body: body))
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
    
    private func outputTransformModel(_ response: UpdateMemberResponse) -> Result<Bool, HTTPError> {
        //MARK: - FIXME
        if response.status {
            return .success(true)
        }
        return .failure(HTTPError.custom(response.message))
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
    
    
    func requestGetFamilyRelations() -> Single<FamilyRelationModel?> {
        return Single.create { (observer) in
            self.familyRelationAPI
                .request()
                .catch{ (error) -> PrimitiveSequence<SingleTrait, FamilyRelationResponse> in
                    if (error as? HTTPError) == HTTPError.expired {
                        return self
                            .familyRelationAPI
                            .httpClient
                            .verify()
                            .andThen(self.familyRelationAPI.request())
                    }
                    return Single.error(error)
                }
                .map{ self.transformOutputFamilyRelationModel($0) }
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
    
    private func transformOutputFamilyRelationModel(_ response : FamilyRelationResponse) -> Result<FamilyRelationModel, HTTPError> {
        if response.status {
            let dataResponse = response.data.map { (data) in
                return FamilyRelationData(id: data.id, name: data.name, isDefault: data.name == "Pribadi" ? true : false )
            }
            
            let model =  FamilyRelationModel(status: response.status, message: response.message, data: dataResponse)
            return .success(model)
        }
        return .failure(HTTPError.custom(response.message))
    }
}
