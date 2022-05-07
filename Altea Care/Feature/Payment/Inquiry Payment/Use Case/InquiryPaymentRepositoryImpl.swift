//
//  InquiryPaymentRepositoryImpl.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import Foundation
import RxSwift
import UIKit
class InquiryPaymentRepositoryImpl: InquiryPaymentRepository {
    private let disposeBag = DisposeBag()
    private let paymentInquiryAPI: PaymentInquiryAPI
    
    init(paymentInquiryAPI: PaymentInquiryAPI) {
        self.paymentInquiryAPI = paymentInquiryAPI
    }
    
    func request(body: PaymentInquiryBody) -> Single<InquiryPaymentModel> {
        return Single.create { (observer) in
            self.paymentInquiryAPI
                .request(body: body)
                .catch { (error) -> PrimitiveSequence<SingleTrait, DetailConsultationResponse> in
                    if (error as? HTTPError) == HTTPError.expired {
                        return self
                            .paymentInquiryAPI
                            .httpClient
                            .verify()
                            .andThen(self.paymentInquiryAPI
                                        .request(body: body))
                    }
                    return Single.error(error)
                }
                .map { self.outputTransformModel($0) }
                .subscribe(onSuccess: { (result) in
                    switch result {
                    case .success(let model):
                        observer(.success(model))
                    case .failure(let error):
                        observer(.failure(error))
                    }
                }, onFailure: { (error) in
                    observer(.failure(error))
                })
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    private func outputTransformModel(_ response: DetailConsultationResponse) -> Result<InquiryPaymentModel, HTTPError> {
        if response.status {
            if let data = response.data {
                let doctor = DoctorCardModel(id: data.doctor.id, doctorImage: data.doctor.photo?.url, hospitalIcon: data.doctor.hospital.logo, name: data.doctor.name, specialty: "\(data.doctor.specialist.name)", hospitalName: data.doctor.hospital.name, date: data.schedule.date, time: "\(data.schedule.timeStart ?? "") - \(data.schedule.timeEnd ?? "")", hospitalId: data.doctor.hospital.id)
                
                var fees : [InquiryPaymentFeeModel] = []
                data.fees.forEach{ fee in
                    let model = InquiryPaymentFeeModel(name: fee.label, price: (fee.amount ?? 0).toCurrency())
                    fees.append(model)

                }
                
                let inq = InquiryPaymentModel(id: "\(data.id)", code: data.orderCode, doctor: doctor, fees: fees, total: data.totalPrice)
                return .success(inq)
            }
        }
        return .failure(HTTPError.custom(response.message))
    }
    
}
