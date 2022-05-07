//
//  RefreshTokenAPIImpl.swift
//  Altea Care
//
//  Created by Hedy on 23/03/21.
//

import Foundation
import RxSwift

class RefreshTokenAPIImpl: RefreshTokenAPI {
    
    private class GenerateRefreshToken: HTTPRequest {
        var method = HTTPMethod.POST
        var path = "/get/refresh-token"
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
    
    func request(parameters: [String: Any]) -> Single<RefreshTokenResponse> {
        return httpClient.send(request: GenerateRefreshToken(parameters: parameters))
    }
}

class GenerateRefreshToken: HTTPRequest {
    var method = HTTPMethod.POST
    var path = "/user/auth/refresh-token"
    var apiVersion = ApiVersion.none
    var parameters: [String: Any]
    var authentication = HTTPAuth.tokenType.basic
    var header = HeaderType.basic
    
    init(token: String) {
        let body = RefreshTokenBody(refreshToken: token)
        self.parameters = body.dictionary ?? [String: Any]()
    }
}
