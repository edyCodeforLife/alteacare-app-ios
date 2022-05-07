//
//  InquiryPaymentRepository.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import Foundation
import RxSwift

protocol InquiryPaymentRepository {
    func request(body: PaymentInquiryBody) -> Single<(InquiryPaymentModel)>
}
