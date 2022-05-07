//
//  LogoutAPIImpl.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 10/05/21.
//

import Foundation
import RxSwift

class LogoutAPIImpl: LogoutAPI {
    
    private class LogoutRequest: HTTPRequest {
        var method = HTTPMethod.POST
        var path = "/user/auth/logout"
        var apiVersion = ApiVersion.none
        var parameters = [String: Any]()
        var authentication = HTTPAuth.tokenType.bearer
        var header = HeaderType.basic
        
        init() {
            self.path = "\(path)"
        }
    }
    
    let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func request() -> Single<LogoutResponse> {
        return httpClient.send(request: LogoutRequest())
    }
}
