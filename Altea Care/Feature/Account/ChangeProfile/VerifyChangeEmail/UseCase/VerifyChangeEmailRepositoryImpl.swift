//
//  VerifyChangeEmailRepositoryImpl.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 26/07/21.
//

import Foundation
import RxCocoa
import RxSwift

class VerifyChangeEmailRepositoryImpl: VerifyChangeEmailRepository {
    
    private let changeEmailVerifyAPI: ChangeEmailVerifyAPI
    private let disposeBag = DisposeBag()
    
    
    init(changeEmailVerifyAPI: ChangeEmailVerifyAPI) {
        self.changeEmailVerifyAPI = changeEmailVerifyAPI
    }
    
    func requestVerifyChangeEmail(body: ChangeEmailVerifyBody) -> Single<VerifyChangeEmailModel> {
        return Single.create { (observer) in
            self.changeEmailVerifyAPI.requestVerifyChangeEmail(body: body)
                .catch { (error) -> PrimitiveSequence<SingleTrait, ChangeEmailVerifyResponse> in
                    if (error as? HTTPError) == HTTPError.expired{
                        return self
                            .changeEmailVerifyAPI
                            .httpClient
                            .verify()
                            .andThen(self.changeEmailVerifyAPI.requestVerifyChangeEmail(body: body))
                    }
                    return Single.error(error)
                }
                .map { self.transformVerifyChangeEmailAddress($0) }
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
    
    func transformVerifyChangeEmailAddress(_ response : ChangeEmailVerifyResponse) -> Result<VerifyChangeEmailModel, HTTPError>{
        if response.status {
            let data = VerifyChangeEmailModel(status: response.status, message: response.message)
            return .success(data)
        }
        return .failure(HTTPError.custom(response.message))
    }
    
    
}
