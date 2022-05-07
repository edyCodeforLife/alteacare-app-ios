//
//  PayConsultationAPI.swift
//  Altea Care
//
//  Created by Tiara on 12/05/21.
//

import Foundation
import RxSwift
protocol PayConsultationAPI: ClientAPI {
    func requestPayment(body: PayConsultationBody) -> Single<PayConsultationResponse>
}
