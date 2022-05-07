//
//  RemoveDocumentAPIImpl.swift
//  Altea Care
//
//  Created by Hedy on 25/03/21.
//

import Foundation
import RxSwift

class RemoveDocumentAPIImpl: RemoveDocumentAPI {

    private class RemoveDocument: HTTPRequest {
        var method = HTTPMethod.POST
        var path = "/appointment/remove-document/"
        var apiVersion = ApiVersion.none
        var parameters : [String: Any]
        var authentication = HTTPAuth.tokenType.bearer
        var header = HeaderType.basic
        
        init(body: [String: Any]) {
            self.parameters = body
        }
    }
    
    let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func request(body: [String: Any]) -> Single<RemoveDocumentResponse> {
        return httpClient.send(request: RemoveDocument(body: body))
    }
}

