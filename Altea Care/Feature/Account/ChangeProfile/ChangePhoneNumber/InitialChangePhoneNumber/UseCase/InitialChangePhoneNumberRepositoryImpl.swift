//
//  InitalChangePhoneNumberRepositoryImpl.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 10/05/21.
//

import Foundation
import RxSwift

class InitialChangePhoneNumberRepositoryImpl : InitialChangePhoneNumberRepository {
    
    private let changePhoneNumberAPI : RequestChangePhoneNumberAPI
    private let disposeBag = DisposeBag()
    
    init(changePhoneNumberAPI : RequestChangePhoneNumberAPI){
        self.changePhoneNumberAPI = changePhoneNumberAPI
    }
    
    func requestSendPhoneNumber(body: RequestChangePhoneNumberBody) -> Single<InitialChangePhoneNumberModel> {
        return Single.create { (observer) in
            self.changePhoneNumberAPI
                .requestSwitchChangePhoneNumber(body: body)
                .catch { (error) -> PrimitiveSequence<SingleTrait, RequestChangePhoneNumberResponse> in
                    if (error as? HTTPError) ==  HTTPError.expired{
                        return self
                            .changePhoneNumberAPI
                            .httpClient
                            .verify()
                            .andThen(self.changePhoneNumberAPI.requestSwitchChangePhoneNumber(body: body))
                    }
                    return Single.error(error)
                }
                .map { self.outputTransformChangePhoneNumber($0)}
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
    
    private func outputTransformChangePhoneNumber(_ response : RequestChangePhoneNumberResponse) -> Result<InitialChangePhoneNumberModel, HTTPError>{
        if response.status{
            return .success(InitialChangePhoneNumberModel(status: response.status, message: response.message))
        }
        return .failure(HTTPError.custom(response.message))
    }
}
