//
//  LoginAPIImpl.swift
//  Altea Care
//
//  Created by Hedy on 07/03/21.
//

import Foundation
import RxSwift

class LoginAPIImpl: LoginAPI {
    
    private class PostLoginRequest: HTTPRequest {
        var method = HTTPMethod.POST
        var path = "/user/auth/login"
        var apiVersion = ApiVersion.none
        var parameters: [String: Any]
        var authentication = HTTPAuth.tokenType.basic
        var header = HeaderType.basic
        
        init(parameters: [String: Any]) {
            self.parameters = parameters
        }
    }
    
    let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func request(parameters: [String: Any]) -> Single<LoginResponse> {
        return httpClient.send(request: PostLoginRequest(parameters: parameters))
    }
}
