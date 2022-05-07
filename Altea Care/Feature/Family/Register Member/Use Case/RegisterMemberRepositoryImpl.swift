//
//  RegisterMemberRepositoryImpl.swift
//  Altea Care
//
//  Created by Hedy on 11/08/21.
//

import Foundation
import RxSwift

class RegisterMemberRepositoryImpl: RegisterMemberRepository {
    
    private let registerMemberAPI: RegisterMemberAPI
    private let addMemberAPI: AddMemberAPI
    private let disposeBag = DisposeBag()
    
    init(registerMemberAPI: RegisterMemberAPI,addMemberAPI: AddMemberAPI) {
        self.registerMemberAPI = registerMemberAPI
        self.addMemberAPI = addMemberAPI
    }
    
    func requestRegister(id: String, body: RegisterMemberBody) -> Single<Bool> {
        return Single.create { (observer) in
            self.registerMemberAPI
                .request(id: id, body: body)
                .catch { (error) -> PrimitiveSequence<SingleTrait, RegisterMemberResponse> in
                    if (error as? HTTPError) == HTTPError.expired {
                        return self
                            .registerMemberAPI
                            .httpClient
                            .verify()
                            .andThen(self.registerMemberAPI.request(id: id, body: body))
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
    
    private func outputTransformModel(_ response: RegisterMemberResponse) -> Result<Bool, HTTPError> {
        if response.status == true {
            return .success(true)
        }
        return .failure(HTTPError.custom(response.message ?? ""))
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
}
