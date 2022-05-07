//
//  FaqsAPIImpl.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 10/05/21.
//

import Foundation
import RxSwift

class FaqsAPIImpl : FaqsAPI {
    
    private class RequestFaq: HTTPRequest {
        var method = HTTPMethod.GET
        var path = "/data/faqs"
        var apiVersion = ApiVersion.none
        var parameters = [String: Any]()
        var authentication = HTTPAuth.tokenType.basic
        var header = HeaderType.basic
        
        init() {
        }
    }
    
    let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func request() -> Single<FaqsResponse> {
        return httpClient.send(request: RequestFaq())
    }
}
