//
//  ForgotPasswordImpl.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 17/03/21.
//

import Foundation
import RxSwift

class ForgotPasswordRepositoryImpl : ForgotPasswordRepository {
    
    private let requestForgotPasswordAPI : RequestForgotPasswordAPI
    private let disposeBag = DisposeBag()
    
    init(api: RequestForgotPasswordAPI) {
        self.requestForgotPasswordAPI = api
    }
    
    func requestForgotPassword(body: RequestForgotPasswordBody) -> Single<ForgotPasswordModel> {
        return Single.create { (observer) in
            self.requestForgotPasswordAPI.request(body: body)
                .catch { (error) -> PrimitiveSequence<SingleTrait, RequestForgotPasswordResponse> in
                    if (error as? HTTPError) == HTTPError.expired
                    {
                        return self
                            .requestForgotPasswordAPI
                            .httpClient
                            .verify()
                            .andThen(self.requestForgotPasswordAPI.request(body: body))
                    }
                    return Single.error(error)
                }
                .map { self.responseTransformToModel($0) }
                .subscribe(onSuccess: { (result) in
                    switch result {
                    case .success(let model):
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
    
    private func responseTransformToModel(_ response : RequestForgotPasswordResponse) -> Result<ForgotPasswordModel, HTTPError> {
        if let status = response.status {
            if status == true{
//                return .success(ForgotPasswordModel(status: response.status ?? false, message: response.message, data: ForgotData(type: response.data?.type ?? "", username: response.data?.username ?? "", canResendAt: response.data?.canResendAt ?? "")))
                return .success(ForgotPasswordModel(status: response.status ?? false, message: response.message))
            }
            return .failure(HTTPError.custom(response.message))
        }
        return .failure(HTTPError.custom(response.message))
    }
}
