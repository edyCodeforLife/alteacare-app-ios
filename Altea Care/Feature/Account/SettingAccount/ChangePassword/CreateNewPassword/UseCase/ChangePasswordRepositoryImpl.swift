//
//  ChangePasswordRepositoryImpl.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 17/03/21.
//

import Foundation
import RxSwift

class ChangePasswordRepositoryImpl: ChangePasswordRepository {
    
    private let changePasswordAPI : ChangePasswordApi
    private let dispose = DisposeBag()
    
    init (changePasswordAPI: ChangePasswordApi) {
        self.changePasswordAPI = changePasswordAPI
    }

    func requestChangePassword(body: ChangePasswordBody) -> Single<ChangePasswordModel> {
        return Single.create { (observer) in
            self.changePasswordAPI
                .request(body: body)
                .catch { (error) -> PrimitiveSequence<SingleTrait, ChangePasswordResponse> in
                    if (error as? HTTPError) == HTTPError.expired {
                        return self
                            .changePasswordAPI
                            .httpClient
                            .verify()
                            .andThen(self.changePasswordAPI.request(body: body))
                    }
                    return Single.error(error)
                }
                .map { self.transformChangePassword($0) }
                .subscribe(onSuccess: { (result) in
                    switch result {
                    case .success(let model) : observer(.success(model))
                    case .failure(let error) : observer(.failure(error))
                    }
                }, onFailure: { (error) in
                    observer(.failure(error))
                }).disposed(by: self.dispose)
            
            return Disposables.create()
        }
    }
    
    func transformChangePassword(_ response : ChangePasswordResponse) -> Result<ChangePasswordModel, HTTPError> {
        if  response.status {
            
                let changePassword = ChangePasswordModel(status: response.status, message: response.message)
                
                return .success(changePassword)
            
          
        }
        return.failure(HTTPError.custom(response.message))
    }
}
