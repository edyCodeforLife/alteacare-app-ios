//
//  BindDocumentAPIImpl.swift
//  Altea Care
//
//  Created by Hedy on 21/05/21.
//

import Foundation
import RxSwift

class BindDocumentAPIImpl: BindDocumentAPI {
    
    private class BindDocument: HTTPRequest {
        var method = HTTPMethod.POST
        var path = "/appointment/add-document"
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
    
    func request(parameters: [String: Any]) -> Single<BindDocumentResponse> {
        return httpClient.send(request: BindDocument(parameters: parameters))
    }
}
