//
//  VoucherRepositoryImpl.swift
//  Altea Care
//
//  Created by Tiara on 11/09/21.
//

import Foundation
import RxSwift

class VoucherRepositoryImpl: VoucherRepository {
    private let disposeBag = DisposeBag()
    private let voucherAPI: VoucherAPI
    
    init(voucherAPI: VoucherAPI) {
        self.voucherAPI = voucherAPI
    }
    
    func request(body: VoucherBody) -> Single<VoucherModel> {
        return Single.create { (observer) in
            self.voucherAPI
                .request(body: body)
                .catch { (error) -> PrimitiveSequence<SingleTrait, VoucherResponse> in
                    if (error as? HTTPError) == HTTPError.expired {
                        return self
                            .voucherAPI
                            .httpClient
                            .verify()
                            .andThen(self.voucherAPI
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
    
    private func outputTransformModel(_ response: VoucherResponse) -> Result<VoucherModel, HTTPError>{
        
        if response.status {
            if let data = response.data {
                let model = VoucherModel(status: true, voucher: VoucherData(voucherCode: data.voucherCode ?? "", afterDiscountPrice: data.grandTotal, discount: data.discount))
                return .success(model)
            }
        }
        return .failure(HTTPError.custom(response.message))
    }

}
