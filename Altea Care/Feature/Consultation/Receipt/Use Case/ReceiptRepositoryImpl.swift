//
//  ReceiptRepositoryImpl.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import Foundation
import RxSwift

class ReceiptRepositoryImpl: ReceiptRepository {
    
    private let disposeBag = DisposeBag()
    private let receiptConsultationAPI: ReceiptConsultationAPI
    
    init(receiptConsultationAPI: ReceiptConsultationAPI) {
        self.receiptConsultationAPI = receiptConsultationAPI
    }
    
    func requestReceiptAPI(body: ReceiptConsultationBody) -> Single<ReceiptModel> {
        return Single.create { (observer) in
            self.receiptConsultationAPI
                .request(body: body)
                .catch { (error) -> PrimitiveSequence<SingleTrait, DetailConsultationResponse> in
                    if (error as? HTTPError) == HTTPError.expired {
                        return self
                            .receiptConsultationAPI
                            .httpClient
                            .verify()
                            .andThen(self.receiptConsultationAPI
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
    
    private func outputTransformModel(_ response: DetailConsultationResponse) -> Result<ReceiptModel, HTTPError> {
        if response.status {
            if let data = response.data {
                let detailPayment = DetailPaymentModel(name: data.transaction?.detail?.name ?? "", icon: data.transaction?.detail?.icon ?? "")
                let payment = PaymentsModel(bank: response.data?.transaction?.bank, type: response.data?.transaction?.type, detail: detailPayment)
                
                let subTotalPrice = data.totalPrice
                var fees : [InquiryPaymentFeeModel] = []
                data.fees.forEach{ fee in
                    let model = InquiryPaymentFeeModel(name: fee.label, price: (fee.amount ?? 0).toCurrency())
                    fees.append(model)
                }
                var consult = data.fees.map { (fee) -> ReceiptSections in
                    let model = ConsultationFeeModel(name: fee.label, isHighlighted: false, price: (fee.amount ?? 0).toCurrency(), paymentMethod: payment, image: nil, fees: fees, priceInNumber: subTotalPrice)
                    return .consultation(model)
                }
                
                let total = ConsultationFeeModel(name: "Harga Total",
                                                 isHighlighted: true, price: subTotalPrice.toCurrency(),
                                                 paymentMethod: payment, image: nil, fees: fees, priceInNumber: subTotalPrice)
                consult.append(.consultation(total))
                
                let consultation = ReceiptModel(item: [ReceiptModelDetail(title: "Telekonsultasi", contents: consult)], totalPrice: data.totalPrice.toCurrency())
                
                return .success(consultation)
            }
        }
        return .failure(HTTPError.custom(response.message))
    }
}
