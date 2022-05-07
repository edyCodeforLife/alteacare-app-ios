//
//  AlteaPaymentWebViewRepositoryImpl.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 28/06/21.
//

import Foundation
import RxSwift

class AlteaPaymentWebViewRepositoryImpl: AlteaPaymentWebViewRepository {
    
    private let disposeBag = DisposeBag()
//    private let payConsultationAPI : PayConsultationAPI
    private let detailAppointmentAPI : DetailAppointmentAPI
    
    init(detailAppointmentAPI : DetailAppointmentAPI) {
        self.detailAppointmentAPI = detailAppointmentAPI
    }
    
    func requestStatusPayment(body: DetailAppointmentBody) -> Single<StatusPaymentModel> {
        return Single.create { (observer) in
            self.detailAppointmentAPI
                .requestDetailAppointment(body: body)
                .catch { (error) -> PrimitiveSequence<SingleTrait, DetailAppointmentResponse> in
                    if (error as? HTTPError) == HTTPError.expired{
                        return self
                            .detailAppointmentAPI
                            .httpClient
                            .verify()
                            .andThen(self.detailAppointmentAPI.requestDetailAppointment(body: body))
                    }
                    return Single.error(error)
                }
                .map { self.outputTransformModel ($0) }
                .subscribe(onSuccess: { (result) in
                    switch result{
                    case .success(let model): observer(.success(model))
                    case .failure(let error): observer(.failure(error))
                    }
                }, onFailure: { (error) in
                    observer(.failure(error))
                }).disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
    
    private func outputTransformModel(_ response : DetailAppointmentResponse) -> Result<StatusPaymentModel, HTTPError> {
        
        if response.status {
            let model = response.data.map { (res) in
                return StatusPaymentModel(status: res.status)
            }!
            return .success(model)
        }
        return .failure(HTTPError.custom(response.message))
    }
}
