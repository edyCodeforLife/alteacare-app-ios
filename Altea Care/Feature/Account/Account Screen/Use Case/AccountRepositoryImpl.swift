//
//  AccountRepositoryImpl.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import Foundation
import RxSwift

class AccountRepositoryImpl: AccountRepository {
    
    private let disposeBag = DisposeBag()
    private let getUserAPI : GetUserAPI
    private let logoutAPI : LogoutAPI
    
    init(getUserAPI : GetUserAPI, logoutAPI : LogoutAPI) {
        self.getUserAPI = getUserAPI
        self.logoutAPI = logoutAPI
    }
    
    func requestLogout() -> Single<LogoutModel?>{
        return Single.create { (observer) in
            self.logoutAPI
                .request()
                .catch { (error) -> PrimitiveSequence<SingleTrait, LogoutResponse> in
                    if (error as? HTTPError) == HTTPError.expired {
                        return self
                            .logoutAPI
                            .httpClient
                            .verify()
                            .andThen(self.logoutAPI.request())
                    }
                    return Single.error(error)
                }
                .map { self.responseTransformModel($0) }
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
    
    private func responseTransformModel(_ response : LogoutResponse) -> Result<LogoutModel?, HTTPError> {
        if response.status {
            let model = response.data.map { res in
                
                return LogoutModel(status: response.status, message: response.message)
            }
            return .success(model)
        }
        return .failure(HTTPError.custom(response.message ?? ""))
    }
    
    func requestGetUserData() -> Single<AccountDataModel> {
        return Single.create { (observer) in
            self.getUserAPI
                .request()
                .catch { (error) -> PrimitiveSequence<SingleTrait, GetUserResponse> in
                    if (error as? HTTPError) == HTTPError.expired {
                        return self
                            .getUserAPI
                            .httpClient
                            .verify()
                            .andThen(self.getUserAPI.request())
                    }
                    return Single.error(error)
            }
                .map { self.transformUserDataModel($0) }
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
    
    private func transformUserDataModel(_ response : GetUserResponse) -> Result<AccountDataModel, HTTPError> {
        if response.status {
            let dataAccount = response.data.map { (res) in
                return AccountDataModel(userName: "\(res.firstName ?? "") \(res.lastName ?? "")", email: res.email ?? "", userPhoto: res.userDetails?.avatar?.formats?.medium ?? "")
            }!
            return .success(dataAccount)
        }
        if response.message == "jwt expired" {
            return .failure(HTTPError.expired)
        }
        return .failure(HTTPError.custom(response.message ))
    }
}
