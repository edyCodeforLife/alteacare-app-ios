//
//  RequestCancelRepositoryImpl.swift
//  Altea Care
//
//  Created by Hedy on 18/12/21.
//

import Foundation
import RxSwift

class RequestCancelRepositoryImpl: RequestCancelRepository {
    
    private let userCancelAPI: UserCancelAPI
    private let disposeBag = DisposeBag()
    
    init(userCancelAPI: UserCancelAPI) {
        self.userCancelAPI = userCancelAPI
    }
    
    func requestCancel(body: UserCancelBody) -> Completable {
        return Completable.create { (observer) in
            self.userCancelAPI
                .requestCancel(body: body.dictionaryWithConvert ?? [String: Any]())
                .catch { (error) -> PrimitiveSequence<SingleTrait, UserCancelResponse> in
                    if (error as? HTTPError) == HTTPError.expired {
                        return self
                            .userCancelAPI
                            .httpClient
                            .verify()
                            .andThen(self.userCancelAPI
                                        .requestCancel(body: body.dictionaryWithConvert ?? [String: Any]()))
                    }
                    return .error(error)
                }
                .map { self.outputTransformModel($0) }
                .subscribe(onSuccess: { (result) in
                    switch result {
                    case .success(_ ):
                        observer(.completed)
                    case .failure(let error):
                        observer(.error(error))
                    }
                }, onFailure: { (error) in
                    observer(.error(error))
                })
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    private func outputTransformModel(_ response: UserCancelResponse) -> Result<Bool, HTTPError> {
        if response.status {
            return .success(true)
        }
        return .failure(HTTPError.custom(response.message ?? "Internal Server Error"))
    }
    
}

