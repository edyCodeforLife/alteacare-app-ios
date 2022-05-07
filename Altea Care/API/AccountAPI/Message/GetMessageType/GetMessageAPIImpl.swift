//
//  GetMessageAPIImpl.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 20/06/21.
//

import Foundation
import RxSwift

class GetMessageAPIImpl : GetMessageTypeAPI{
    
    private class GetMessageType : HTTPRequest {
        var method = HTTPMethod.GET
        var path = "/data/message-types"
        var apiVersion = ApiVersion.none
        var parameters = [String: Any]()
        var authentication = HTTPAuth.tokenType.basic
        var header = HeaderType.basic
        
        init() {
            self.path = "\(path)"
        }
    }
    
    let httpClient: HTTPClient
    
    init(httpClient : HTTPClient) {
        self.httpClient = httpClient
    }
    
    func request() -> Single<GetMessageTypeResponse> {
        return httpClient.send(request: GetMessageType())
    }
}
