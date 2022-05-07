//
//  FaqRepositoryImpl.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 10/05/21.
//

import Foundation
import RxSwift

class FaqRepositoryImpl : FaqRepository {

    private let disposeBag = DisposeBag()
    private let faqAPI : FaqsAPI
    
    init(faqAPI : FaqsAPI) {
        self.faqAPI = faqAPI
    }
    
    func requestGetFaq() -> Single<[FaqModel]> {
        return Single.create { (observer) in
            self.faqAPI
                .request()
                .catch { (error) -> PrimitiveSequence<SingleTrait, FaqsResponse> in
                    if (error as? HTTPError) == HTTPError.expired {
                        return self
                            .faqAPI
                            .httpClient
                            .verify()
                            .andThen(self.faqAPI.request())
                    }
                    return Single.error(error)
                }
                .map { self.transformFaqResponse($0) }
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
    
    private func transformFaqResponse(_ response : FaqsResponse) -> Result<[FaqModel], HTTPError> {
        if response.status {
            let model = response.data.map { (res) in
                return FaqModel(question: res.question, answer: res.answer)
            }
            return .success(model)
        }
        return .failure(HTTPError.custom(response.message))
    }
}
