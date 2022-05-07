//
//  ChangeEmailRepositoryImpl.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 21/07/21.
//

import Foundation
import RxSwift

class ChangeEmailRepositoryImpl : ChangeEmailRepository{
    private let disposeBag = DisposeBag()
    private let requestChangeEmailAPI: RequestChangeEmailAPI
    
    init(changeEmailAPI: RequestChangeEmailAPI) {
        self.requestChangeEmailAPI = changeEmailAPI
    }
    
    func requestChangeEmail(body: RequestChangeEmailBody) -> Single<ChangeEmailModel> {
        return Single.create { (observer) in
            self.requestChangeEmailAPI
                .requestChangeEmail(body: body)
                .catch { (error) -> PrimitiveSequence<SingleTrait, RequestChangeEmailResponse> in
                    if (error as? HTTPError) == HTTPError.expired{
                        return self
                            .requestChangeEmailAPI
                            .httpClient
                            .verify()
                            .andThen(self.requestChangeEmailAPI.requestChangeEmail(body: body))
                    }
                    return Single.error(error)
                }
                .map { self.transformChangeEmailAddress($0) }
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
    
    func transformChangeEmailAddress(_ response : RequestChangeEmailResponse) -> Result<ChangeEmailModel, HTTPError>{
        if response.status {
            let data = ChangeEmailModel(status: response.status, message: response.message)
            return .success(data)
        }
        return .failure(HTTPError.custom(response.message))
    }
}
