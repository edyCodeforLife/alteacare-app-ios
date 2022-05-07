//
//  ForceUpdateRepositoryImpl.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 19/09/21.
//

import Foundation
import RxSwift

class ForceUpdateRepositoryImpl : ForceUpdateRepository {
    
    private let forceUpdateAPI : ForceUpdateAPI
    private let disposeBag = DisposeBag()
    
    init(forceUpdateAPI : ForceUpdateAPI) {
        self.forceUpdateAPI = forceUpdateAPI
    }
    
//    func requestForceUpdate() -> Single<ForceUpdateModel> {
//        return Single.create { (observer) in
//            self.forceUpdateAPI
//                .requestForceUpdate()
//                .catch { (error) -> PrimitiveSequence<SingleTrait, ForceUpdateResponse> in
//                    if (error as? HTTPError) == HTTPError.expired {
//                        return self
//                            .forceUpdateAPI
//                            .httpClient
//                            .verify()
//                            .andThen(self.forceUpdateAPI.requestForceUpdate())
//                    }
//                    return Single.error(error)
//                }
//                .map { self.outputTranforModel($0) }
//                .subscribe(onSuccess: { (result) in
//                    switch result {
//                    case .success(let model):
//                        observer(.success(model))
//                    case .failure(let error):
//                        observer(.failure(error))
//                    }
//                }, onFailure: { (error) in
//                    observer(.failure(error))
//                })
//                .disposed(by: self.disposeBag)
//            
//            return Disposables.create()
//        }
//    }
//    
//    private func outputTranforModel(_ response : ForceUpdateResponse) -> Result<ForceUpdateModel, HTTPError> {
//        if response.status == "OK" {
//            let data = ForceUpdateModel(isUpdateRequired: response.data?.isUpdateRequired)
//            
//            return .success(data)
//        }
//        return .failure(HTTPError.custom(response.message ))
//    }
//    
    
}
