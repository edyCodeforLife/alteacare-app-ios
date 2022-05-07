//
//  PayConsultationAPIImpl.swift
//  Altea Care
//
//  Created by Tiara on 12/05/21.
//

import Foundation
import RxSwift

class PayConsultationAPIImpl: PayConsultationAPI {
    
    private class PostPayment: HTTPRequest {
        var method = HTTPMethod.POST
        var path = "/appointment/pay"
        var apiVersion = ApiVersion.none
        var parameters: [String: Any]
        var authentication = HTTPAuth.tokenType.bearer
        var header = HeaderType.basic
        
        init(body: PayConsultationBody) {
            self.parameters = body.dictionary ?? [String:Any]()
        }
    }
    
    let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func requestPayment(body: PayConsultationBody) -> Single<PayConsultationResponse>{
        return httpClient.send(request: PostPayment(body: body))
    }
}
