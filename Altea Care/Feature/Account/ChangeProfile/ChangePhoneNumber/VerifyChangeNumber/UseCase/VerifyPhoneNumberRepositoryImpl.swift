//
//  VerifyPhoneNumberRepositoryImpl.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 10/05/21.
//

import Foundation
import RxSwift

class VerifyPhoneNumberRepositoryImpl : VerifyPhoneNumberRepository {
    
    private let verifyPhoneNumberAPI : ChangePhoneNumberAPI
    private let disposeBag = DisposeBag()
    
    init(verifyPhoneNumberAPI : ChangePhoneNumberAPI) {
        self.verifyPhoneNumberAPI = verifyPhoneNumberAPI
    }
    
    func requestVerifyPhoneNumber(body: ChangePhoneNumberBody) -> Single<VerifyPhoneNumberModel> {
        return Single.create { (observer) in
            self.verifyPhoneNumberAPI
                .requestChangePhoneNumber(body: body)
                .catch { (error) -> PrimitiveSequence<SingleTrait, ChangePhoneNumberResponse> in
                    if (error as? HTTPError) == HTTPError.expired{
                        return self
                            .verifyPhoneNumberAPI
                            .httpClient
                            .verify()
                            .andThen(self.verifyPhoneNumberAPI.requestChangePhoneNumber(body: body))
                    }
                    return Single.error(error)
                }
                .map { self.transformVerifyPhoneNumber($0) }
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
    
    func transformVerifyPhoneNumber(_ response : ChangePhoneNumberResponse) -> Result<VerifyPhoneNumberModel, HTTPError>{
        if response.status {
            let data = VerifyPhoneNumberModel(status: response.status, message: response.message)
            return .success(data)
        }
        return .failure(HTTPError.custom(response.message))
    }
}
