//
//  RequestForgotPasswordAPIImpl.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 26/04/21.
//

import Foundation
import RxSwift

class RequestForgotPasswordAPIImpl : RequestForgotPasswordAPI {
    
    private class GetRequestForgotPassword : HTTPRequest {
        
        var method = HTTPMethod.POST
        var path = "/user/password/forgot"
        var apiVersion = ApiVersion.none
        var parameters = [String: Any]()
        var authentication = HTTPAuth.tokenType.basic
        var header = HeaderType.basic
        
        init(body : RequestForgotPasswordBody) {
            self.parameters = body.dictionary ?? [String:Any]()
        }
    }
    
    var httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func request(body: RequestForgotPasswordBody) -> Single<RequestForgotPasswordResponse> {
        return httpClient.send(request: GetRequestForgotPassword(body: body))
    }
}
