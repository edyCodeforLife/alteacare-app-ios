//
//  PaymentMethodRepositotyImpl.swift
//  Altea Care
//
//  Created by Hedy on 10/05/21.
//

import Foundation
import RxSwift

class PaymentMethodRepositotyImpl: PaymentMethodRepository {
    private let disposeBag = DisposeBag()
    private let paymentMethodAPI: PaymentMethodAPI
    private let payConsultationAPI: PayConsultationAPI
    
    init(paymentMethodAPI: PaymentMethodAPI, payConsultationAPI: PayConsultationAPI) {
        self.paymentMethodAPI = paymentMethodAPI
        self.payConsultationAPI = payConsultationAPI
    }
    
    func request(parameter: [String:Any]) -> Single<[PaymentMethodModel]> {
        return Single.create { (observer) in
            self.paymentMethodAPI
                .request(parameters: parameter)
                .catch { (error) -> PrimitiveSequence<SingleTrait, PaymentMethodResponse> in
                    if (error as? HTTPError) == HTTPError.expired {
                        return self
                            .paymentMethodAPI
                            .httpClient
                            .verify()
                            .andThen(self.paymentMethodAPI
                                        .request(parameters: parameter))
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
    
    func requestPayment(body: PayConsultationBody) -> Single<PaymentMethodSelectedModel> {
        return Single.create { (observer) in
            self.payConsultationAPI
                .requestPayment(body: body)
                .catch { (error) -> PrimitiveSequence<SingleTrait, PayConsultationResponse> in
                    if (error as? HTTPError) == HTTPError.expired {
                        return self
                            .payConsultationAPI
                            .httpClient
                            .verify()
                            .andThen(self.payConsultationAPI
                                        .requestPayment(body: body))
                    }
                    return Single.error(error)
                }
                .map { self.outputTransform($0) }
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
    
    private func outputTransformModel(_ response: PaymentMethodResponse) -> Result<[PaymentMethodModel], HTTPError> {
        if response.status {
            var dataArr : [PaymentMethodModel] = []
            if response.data?.isEmpty == false {
                response.data?.forEach{ res in
                    var pm : [PaymentMethodModelItem] = []
                    res.paymentMethods?.forEach { a in
                        let o = PaymentMethodModelItem(code: a.code ?? "",
                                                       name: a.name ?? "",
                                                       desc: a.paymentMethodDescription ?? "",
                                                       icon: a.icon ?? "")
                        pm.append(o)
                    }
                    let data = PaymentMethodModel(type: res.type ?? "", paymentMethod: pm)
                    dataArr.append(data)
                }
            }
            return .success(dataArr)
        }
        return .failure(HTTPError.custom(response.message ?? ""))
    }
    
    private func outputTransform(_ response: PayConsultationResponse) -> Result<PaymentMethodSelectedModel, HTTPError> {
        
        if response.status {
            let model = response.data.map { (res) in
                return PaymentMethodSelectedModel(type: res.type ?? "", paymentUrl: res.paymentUrl ?? "", token: res.token ?? "", total: res.total ?? 0, refId: res.refId ?? "")
            }!
            
            return .success(model)
        }
        return .failure(HTTPError.custom(response.message ?? ""))
    }
}
