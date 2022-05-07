//
//  DrawerCallBookingRepositoryImpl.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 02/08/21.
//

import Foundation
import RxSwift

class DrawerCallBookingRepositoryImpl: DrawerCallBookingRepository {
    
    private let disposeBag = DisposeBag()
    private let createBookingAPI : CreateConsultationAPI
    
    init(createBookingAPI: CreateConsultationAPI) {
        self.createBookingAPI = createBookingAPI
    }
    
    func requestConsultation(body: CreateConsultationBody) -> Single<DataCreateConsultation> {
        return Single.create { (observer) in
            self.createBookingAPI.request(parameters: body.dictionary ?? [String:Any]())
                .catch { (error) -> PrimitiveSequence<SingleTrait, CreateConsultationResponse> in
                    if (error as? HTTPError) == HTTPError.expired{
                        return self
                            .createBookingAPI
                            .httpClient
                            .verify()
                            .andThen(self.createBookingAPI.request(parameters: body.dictionary ?? [String: Any]()))
                    }
                    return Single.error(error)
                }
                .map { self.outputTransformModel($0) }
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
    
    private func outputTransformModel(_ response : CreateConsultationResponse) -> Result<DataCreateConsultation, HTTPError> {
        if response.status{
            let model = DataCreateConsultation(appointmentId: response.data.appointmentId, orderCode: response.data.orderCode, roomCode: response.data.roomCode, appointmentMethod: response.data.appointmentMethod, status: response.data.status, statusDetail: response.data.statusDetail,inOperationalHour: response.data.inOperationalHour)
            return .success(model)
        }
        
        return .failure(HTTPError.custom(response.message))
    }
}
