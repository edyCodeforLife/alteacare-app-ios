//
//  AppTokenAPIImpl.swift
//  Altea Care
//
//  Created by Hedy on 23/03/21.
//

import Foundation
import RxSwift

class AppTokenAPIImpl: AppTokenAPI {
    
    private class GenerateAppToken: HTTPRequest {
        var method = HTTPMethod.POST
        var path = "/token/get"
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
    
    func request(parameters: [String: Any]) -> Single<AppTokenResponse> {
        return httpClient.send(request: GenerateAppToken(parameters: parameters))
    }
}
