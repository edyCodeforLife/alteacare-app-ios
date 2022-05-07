//
//  ChangeEmailAddressRepositoryImpl.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 15/03/21.
//

import Foundation
import RxSwift

class ChangeEmailAddressRepositoryImpl: ChangeEmailAddressRepository {
    
    private let apiChangeEmail : RegistrationChangeEmailAPI
    private let disposeBag = DisposeBag()
    
    init(api: RegistrationChangeEmailAPI) {
        self.apiChangeEmail = api
    }
    
    func requestChangeEmail(body: RegistrationChangeEmailBody) -> Single<ChangeEmailAddressModel> {
        return Single.create { (observer) in
            self.apiChangeEmail.request(body: body.dictionary ?? [String : Any]())
                .catch{ (error) -> PrimitiveSequence<SingleTrait, RegistrationChangeEmailResponse> in
                    if (error as? HTTPError) == HTTPError.expired {
                        return self
                            .apiChangeEmail
                            .httpClient
                            .verify()
                            .andThen(self.apiChangeEmail.request(body: body.dictionary ?? [String : Any]()))
                    }
                    return Single.error(error)
                }
                .map { self.transformResponseToModel($0) }
                .subscribe(onSuccess: { (result) in
                    switch result {
                    case .success(let model) :
                        observer(.success(model))
                    case .failure(let error) :
                        observer(.failure(error))
                    }
                }, onFailure: { (erorr) in
                    observer(.failure(erorr))
                }).disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
    
    private func transformResponseToModel(_ response  : RegistrationChangeEmailResponse) -> Result<ChangeEmailAddressModel, HTTPError>{
        if let status = response.status {
            if status == true {
                let changeEmailResponse =  ChangeEmailAddressModel(status: response.status, message: response.message)
                
                return .success(changeEmailResponse)
            }
            return .failure(HTTPError.custom(response.message))
        }
        return .failure(HTTPError.internalError)
    }
}
