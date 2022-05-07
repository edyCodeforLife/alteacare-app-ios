//
//  PaymentInquiryAPIImpl.swift
//  Altea Care
//
//  Created by Hedy on 22/03/21.
//

import Foundation
import RxSwift

class PaymentInquiryAPIImpl: PaymentInquiryAPI {

    private class GetConsultation: HTTPRequest {
        var method = HTTPMethod.GET
        var path = "/appointment/detail/"
        var apiVersion = ApiVersion.none
        var parameters = [String: Any]()
        var authentication = HTTPAuth.tokenType.bearer
        var header = HeaderType.basic
        
        init(body: PaymentInquiryBody) {
            self.path = "\(path)\(body.id)"
        }
    }
    
    let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func request(body: PaymentInquiryBody) -> Single<DetailConsultationResponse> {
        return httpClient.send(request: GetConsultation(body: body))
    }
}
