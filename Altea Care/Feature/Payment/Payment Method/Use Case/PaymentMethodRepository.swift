//
//  PaymentMethodRepository.swift
//  Altea Care
//
//  Created by Hedy on 10/05/21.
//

import Foundation
import RxSwift

protocol PaymentMethodRepository {
    func request(parameter: [String:Any]) -> Single<([PaymentMethodModel])>
    func requestPayment(body: PayConsultationBody) -> Single<(PaymentMethodSelectedModel)>
}
