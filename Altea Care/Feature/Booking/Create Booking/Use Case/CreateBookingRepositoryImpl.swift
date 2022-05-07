//
//  CreateBookingRepositoryImpl.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import Foundation
import RxSwift

class CreateBookingRepositoryImpl: CreateBookingRepository {
    
    private let detailConsultationApi: DetailConsultationAPI
    private let disposeBag = DisposeBag()
    
    init(api: DetailConsultationAPI) {
        self.detailConsultationApi = api
    }
    
    func requestAppointment(id: String) -> Single<CreateBookingModel> {
        return Single.create { (observer) in
            self.detailConsultationApi
                .request(id: id)
                .catch { (error) ->
                    PrimitiveSequence<SingleTrait, DetailConsultationResponse> in
                    if (error as? HTTPError) == HTTPError.expired {
                        return self
                            .detailConsultationApi
                            .httpClient
                            .verify()
                            .andThen(self.detailConsultationApi.request(id: id))
                    }
                    return Single.error(error)
                }
                .map { self.outputTransformModel($0) }
                .subscribe(
                    onSuccess: { (result) in
                        switch result {
                        case .success(let model) : observer(.success(model))
                        case .failure(let error) : observer(.failure(error))
                        }
                    }, onFailure: { (error) in observer(.failure(error))
                    })
                .disposed(by: self.disposeBag)

            return Disposables.create()
        }
    }
    
    private func outputTransformModel(_ response: DetailConsultationResponse) -> Result<CreateBookingModel, HTTPError> {

        return .failure(HTTPError.custom(response.message))
    }
}
