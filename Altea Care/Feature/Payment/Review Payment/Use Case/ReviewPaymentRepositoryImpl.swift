//
//  ReviewPaymentRepositoryImpl.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import Foundation
import RxSwift
import RxCocoa

class ReviewPaymentRepositoryImpl: ReviewPaymentRepository {
   
    private let disposeBag = DisposeBag()
    private let stateRelay = BehaviorRelay<BasicUIState>(value: .loading)
    private let detailAppointmentAPI : DetailAppointmentAPI
   
    init(detailAppointmentAPI : DetailAppointmentAPI) {
        self.detailAppointmentAPI = detailAppointmentAPI
    }
    
    func requestAppointmentDetail(body: DetailAppointmentBody) -> Single<ReviewPaymentModel> {
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
                .map { self.outputTransformDetailModel ($0) }
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
    
    private func outputTransformDetailModel(_ response : DetailAppointmentResponse) -> Result<ReviewPaymentModel, HTTPError> {

        if response.status {
            if let data = response.data {
                let doctor = DoctorCardModel(id: data.doctor.id, doctorImage: data.doctor.photo?.formats.medium, hospitalIcon: data.doctor.hospital.logo, name: data.doctor.name, specialty: "\(data.doctor.specialist.name)", hospitalName: data.doctor.hospital.name, date: data.schedule.date, time: "\(data.schedule.timeStart ?? "") - \(data.schedule.timeEnd ?? "")", hospitalId: data.doctor.hospital.id)
                
                var fees : [InquiryPaymentFeeModel] = []
                data.fees.forEach{ fee in
                    let model = InquiryPaymentFeeModel(name: fee.label, price: (fee.amount ?? 0).toCurrency())
                    fees.append(model)

                }
                
                let inq = ReviewPaymentModel(orderId: "\(data.id)", orderCode: data.orderCode, doctor: doctor, fees: fees, total: data.totalPrice)
                return .success(inq)
            }
        }
        return .failure(HTTPError.custom(response.message))
    }
}
