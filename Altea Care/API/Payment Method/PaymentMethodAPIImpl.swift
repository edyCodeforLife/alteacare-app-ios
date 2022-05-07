//
//  PaymentMethodAPIImpl.swift
//  Altea Care
//
//  Created by Hedy on 10/05/21.
//

import Foundation
import RxSwift

class PaymentMethodAPIImpl: PaymentMethodAPI {
    
    private class GetPaymentMethod: HTTPRequest {
        var method = HTTPMethod.GET
        var path = "/data/payment-types"
        var apiVersion = ApiVersion.none
        var parameters: [String: Any]
        var authentication = HTTPAuth.tokenType.bearer
        var header = HeaderType.basic
        
        init(parameters: [String: Any]) {
            self.parameters = parameters
        }
    }
    
    let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func request(parameters: [String: Any]) -> Single<PaymentMethodResponse> {
        return httpClient.send(request: GetPaymentMethod(parameters: parameters))
    }
}
