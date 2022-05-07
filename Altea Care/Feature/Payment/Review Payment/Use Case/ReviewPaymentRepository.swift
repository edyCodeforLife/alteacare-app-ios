//
//  ReviewPaymentRepository.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import Foundation
import RxSwift

protocol ReviewPaymentRepository {
    func requestAppointmentDetail(body : DetailAppointmentBody) -> Single<ReviewPaymentModel>
}
