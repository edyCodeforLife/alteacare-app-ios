//
//  AlteaPaymentWebViewRepository.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 28/06/21.
//

import Foundation
import RxSwift

protocol AlteaPaymentWebViewRepository {
    func requestStatusPayment(body : DetailAppointmentBody) -> Single<StatusPaymentModel>
}
