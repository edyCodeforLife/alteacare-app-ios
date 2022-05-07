//
//  PaymentMethodAPI.swift
//  Altea Care
//
//  Created by Hedy on 10/05/21.
//

import Foundation
import RxSwift

protocol PaymentMethodAPI: ClientAPI {
    func request(parameters: [String: Any]) -> Single<PaymentMethodResponse>
}
