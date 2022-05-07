//
//  TermRefundCancelAPIImpl.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 10/06/21.
//

import Foundation
import RxSwift

class TermRefundCancelAPIImpl : TermRefundCancelAPI {
    
    private class GetTermRefundCancel : HTTPRequest {
        var method = HTTPMethod.GET
        var path = "/data/blocks/TERM_REFUND_CANCEL"
        var apiVersion = ApiVersion.none
        var parameters = [String: Any]()
        var authentication = HTTPAuth.tokenType.basic
        var header = HeaderType.basic
        
        init() {
        }
    }
    
    let httpClient: HTTPClient
    
    init(httpClient : HTTPClient) {
        self.httpClient = httpClient
    }
    
    func request() -> Single<TermRefundCancelResponse> {
        return httpClient.send(request: GetTermRefundCancel())
    }
}
