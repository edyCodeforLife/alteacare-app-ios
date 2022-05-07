//
//  OldPasswordRepositoryImpl.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 05/04/21.
//

import Foundation
import RxSwift

class OldPasswordRepositoryImpl: OldPasswordRepository {
    
    private let checkOldPasswordAPI : CheckOldPasswordAPI
    private let disposeBag = DisposeBag()
    
    init(checkOldPasswordAPI: CheckOldPasswordAPI) {
        self.checkOldPasswordAPI = checkOldPasswordAPI
    }
    
    func requestCheckOldPassword(body: CheckOldPasswordBody) -> Single<OldPasswordModel> {
        return Single.create { (observer) in
            self.checkOldPasswordAPI
                .request(body: body)
                .catch { (error) -> PrimitiveSequence<SingleTrait, CheckOldPasswordResponse> in
                    if (error as? HTTPError) == HTTPError.expired {
                        return self
                            .checkOldPasswordAPI
                            .httpClient
                            .verify()
                            .andThen(self.checkOldPasswordAPI.request(body: body))
                    }
                    return Single.error(error)
                }
                .map { self.outputTransformCheckOldPassword($0) }
                .subscribe(onSuccess: { (result) in
                    switch result{
                    case .success(let status): observer(.success(status))
                    case .failure(let error): observer(.failure(error))
                    }
                }, onFailure: { (error) in
                    observer(.failure(error))
                }).disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
    
    private func outputTransformCheckOldPassword(_ response : CheckOldPasswordResponse) -> Result<OldPasswordModel, HTTPError>{
        if response.status{
            return .success(OldPasswordModel(status: response.status, message: response.message))
        }
        return .failure(HTTPError.custom(response.message))
    }
}
