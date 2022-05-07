//
//  PaymentInquiryAPI.swift
//  Altea Care
//
//  Created by Hedy on 22/03/21.
//

import Foundation
import RxSwift

protocol PaymentInquiryAPI: ClientAPI {
    func request(body: PaymentInquiryBody) -> Single<DetailConsultationResponse>
}
