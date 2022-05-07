//
//  RegisterAPIImpl.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 10/03/21.
//

import Foundation
import RxSwift

//Not Ready to use
class RegisterAPIImpl: RegisterAPI {
    
    private class PostRegisterRequest : HTTPRequest {
        var method = HTTPMethod.POST
        var path = "/user/auth/register"
        var parameters = [String : Any]()
        var apiVersion = ApiVersion.none
        var authentication = HTTPAuth.tokenType.basic
        var header = HeaderType.basic
        
        init(body : [String: Any]) {
            self.parameters = body
        }
    }
    
    let httpClient: HTTPClient
    
    init(httpClient : HTTPClient) {
        self.httpClient = httpClient
    }
    
    func request(body: [String : Any]) -> Single<RegisterResponse> {
        return httpClient.send(request: PostRegisterRequest(body: body))
    }
}
