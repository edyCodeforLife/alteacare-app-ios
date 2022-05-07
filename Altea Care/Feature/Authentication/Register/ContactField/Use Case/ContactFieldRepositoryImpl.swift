//
//  ContactFieldRepositoryImpl.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 15/03/21.
//

import Foundation
import RxSwift
import RxCocoa

class ContactFieldRepositoryImpl : ContactFieldRepository {
    
    private let checkEmailRegisterAPI : CheckEmailRegisterAPI
    private let disposeBag = DisposeBag()
    
    init(checkEmailRegisterAPI : CheckEmailRegisterAPI) {
        self.checkEmailRegisterAPI = checkEmailRegisterAPI
    }
    
    func requestCheckEmailRegister(body: CheckEmailRegisterBody) -> Single<CheckEmailRegisterModel?> {
        return Single.create { (observer) in
            self.checkEmailRegisterAPI
                .requestCheckEmailRegister(body: body)
                .catch { (error) -> PrimitiveSequence<SingleTrait, CheckEmailRegisterResponse> in
                    if (error as? HTTPError) == HTTPError.expired {
                        return self
                            .checkEmailRegisterAPI
                            .httpClient
                            .verify()
                            .andThen(self.checkEmailRegisterAPI.requestCheckEmailRegister(body: body))
                    }
                    return Single.error(error)
                }
                .map { self.transformResponseCheckEmail($0) }
                .subscribe(onSuccess: { (result) in
                    switch result {
                    case .success(let model) : observer(.success(model))
                    case .failure(let error) : observer(.failure(error))
                    }
                }, onFailure: { (error) in
                    observer(.failure(error))
                }).disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    private func transformResponseCheckEmail(_ response : CheckEmailRegisterResponse) -> Result<CheckEmailRegisterModel, HTTPError> {
        if response.status{
            let data = CheckEmailData(isEmailAvailable: response.data.isEmailAvailable, isPhoneAvailable: response.data.isPhoneAvailable)
            
            let checkEmailRegister = CheckEmailRegisterModel(status: response.status, message: response.message, data: data)
            
            return .success(checkEmailRegister)
        }
        return .failure(HTTPError.custom(response.message))
    }
}
