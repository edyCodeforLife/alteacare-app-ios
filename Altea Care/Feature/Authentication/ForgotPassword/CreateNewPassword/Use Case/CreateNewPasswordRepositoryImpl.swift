//
//  CreateNewPasswordImpl.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 17/03/21.
//

import Foundation
import RxSwift

class CreateNewPasswordRepositoryImpl: CreateNewPasswordRepository {
   
    private let changePasswordAPI : ChangePasswordApi
    private let disposeBag =  DisposeBag()
    
    init(api: ChangePasswordApi) {
        self.changePasswordAPI = api
    }
    
    func requestCreateNewPassword(body : ChangePasswordBody) -> Single<CreateNewPasswordModel> {
        return Single.create { (observer) in
            self.changePasswordAPI.request(body: body)
                .catch { (error) -> PrimitiveSequence<SingleTrait, ChangePasswordResponse> in
                    if (error as? HTTPError) == HTTPError.expired{
                        return self
                            .changePasswordAPI
                            .httpClient
                            .verify()
                            .andThen(self.changePasswordAPI.request(body: body))
                    }
                    return Single.error(error)
                }
                .map { self.responseTransformToModel($0) }
                .subscribe(onSuccess: { (result) in
                    switch result {
                    case .success(let model) :
                        observer(.success(model))
                    case .failure(let error) :
                        observer(.failure(error))
                    }
                }, onFailure: { (error) in
                    observer(.failure(error))
                }).disposed(by: self.disposeBag)

            return Disposables.create()
        }
    }
    
    private func responseTransformToModel (_ response : ChangePasswordResponse) -> Result<CreateNewPasswordModel, HTTPError> {
        if response.status {
            return .success(CreateNewPasswordModel(status: response.status, message: response.message))
        }
        return .failure(HTTPError.custom(response.message))
    }
}
