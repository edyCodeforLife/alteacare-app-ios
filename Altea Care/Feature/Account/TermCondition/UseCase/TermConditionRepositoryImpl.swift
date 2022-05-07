//
//  TermConditionRepositoryImpl.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 11/05/21.
//

import Foundation
import RxSwift
import RxCocoa

class TermConditionRepositoryImpl: TermConditionRepository {
    
    private let disposeBag = DisposeBag()
    private let termConditionAPI : TermConditionAPI
    
    init(termConditionAPI : TermConditionAPI){
        self.termConditionAPI = termConditionAPI
    }
    
    func requestTermConditionAccount() -> Single<TermConditionModel>{
        return Single.create { (observer) in
            self.termConditionAPI
                .request()
                .catch { (error) -> PrimitiveSequence<SingleTrait, TermConditionResponse> in
                    if (error as? HTTPError) == HTTPError.expired{
                        return self
                            .termConditionAPI
                            .httpClient
                            .verify()
                            .andThen(self.termConditionAPI.request())
                    }
                    return Single.error(error)
                }
                .map { self.responseTransformTermCondition($0) }
                .subscribe(onSuccess: { (result) in
                    switch result {
                    case .success(let model): observer(.success(model))
                    case .failure(let error): observer(.failure(error))
                    }
                }, onFailure: { (error) in
                    observer(.failure(error))
                }).disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
    
    private func responseTransformTermCondition(_ response : TermConditionResponse) -> Result<TermConditionModel, HTTPError> {
        if response.status{
            let termCondtionData = response.data.map { (res) in
                return TermConditionModel(text: res.text)
            }!
            return .success(termCondtionData)
        }
        return .failure(HTTPError.custom(response.message))
    }
}
