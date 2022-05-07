//
//  TermConditionAPIImpl.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 10/05/21.
//

import Foundation
import RxSwift

class TermConditionAPIImpl : TermConditionAPI {
    
    private class GetTermConditionRequest: HTTPRequest {
        var method = HTTPMethod.GET
        var path = "/data/blocks/TERMS_CONDITION"
        var apiVersion = ApiVersion.none
        var parameters = [String: Any]()
        var authentication = HTTPAuth.tokenType.basic
        var header = HeaderType.basic
        
        init() {
            self.path = "\(path)"
        }
    }
    
    let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func request() -> Single<TermConditionResponse> {
        return httpClient.send(request: GetTermConditionRequest())
    }
}
