//
//  GetUserAPIImpl.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 10/05/21.
//

import Foundation
import RxSwift


class GetUserAPIImpl : GetUserAPI {
    
    private class GetUserRequest: HTTPRequest {
        var method = HTTPMethod.GET
        var path = "/user/profile/me"
        var apiVersion = ApiVersion.none
        var parameters = [String: Any]()
        var authentication = HTTPAuth.tokenType.bearer
        var header = HeaderType.basic
        
        init() {
            self.path =  "\(path)"
        }
    }
    
    let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func request() -> Single<GetUserResponse> {
        return httpClient.send(request: GetUserRequest())
    }
}
