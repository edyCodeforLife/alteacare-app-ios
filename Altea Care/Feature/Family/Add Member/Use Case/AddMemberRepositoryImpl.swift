//
//  AddMemberRepositoryImpl.swift
//  Altea Care
//
//  Created by Hedy on 11/08/21.
//

import Foundation
import RxSwift

class AddMemberRepositoryImpl: AddMemberRepository {
    private let addMemberAPI: AddMemberAPI
    private let countryAPI : CountryAPI
    private let familyRelationAPI : FamilyRelationAPI
    private let disposeBag = DisposeBag()
    
    init(addMemberAPI: AddMemberAPI, countryAPI : CountryAPI, familyRelationAPI: FamilyRelationAPI) {
        self.addMemberAPI = addMemberAPI
        self.countryAPI = countryAPI
        self.familyRelationAPI = familyRelationAPI
    }
    
    func requestAdd(body: AddMemberBody) -> Single<AddMemberModel> {
        return Single.create { (observer) in
            self.addMemberAPI
                .request(body: body)
                .catch { (error) -> PrimitiveSequence<SingleTrait, AddMemberResponse> in
                    if (error as? HTTPError) == HTTPError.expired {
                        return self
                            .addMemberAPI
                            .httpClient
                            .verify()
                            .andThen(self.addMemberAPI.request(body: body))
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
    
    private func outputTransformModel(_ response: AddMemberResponse) -> Result<AddMemberModel, HTTPError> {
        //MARK: - FIXME
        if response.status {
            if let data = response.data {
                let dataModel = AddMemberModel(id: data.id,
                                               relationship: data.familyRelationType?.name,
                                               firstName: data.firstName,
                                               lastName: data.lastName,
                                               gender: data.gender,
                                               dob: data.birthDate,
                                               placeOfBirth: data.birthCountry?.name,
                                               cityOfBirth: data.birthPlace,
                                               citizenship: data.country?.name,
                                               idNumber: data.cardId,
                                               address: data.addressId)
                return .success(dataModel)
            }
            return .failure(HTTPError.custom(response.message ))
        }
        return .failure(HTTPError.custom(response.message ))
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
    
    private func transformOutputFamilyRelationModel(_ response : FamilyRelationResponse) -> Result<FamilyRelationModel, HTTPError> {
        if response.status {
            let dataResponse = response.data.map { (data) in
                return FamilyRelationData(id: data.id, name: data.name, isDefault: data.isDefault)
            }
            
            let model =  FamilyRelationModel(status: response.status, message: response.message, data: dataResponse)
            return .success(model)
        }
        return .failure(HTTPError.custom(response.message))
    }
}
