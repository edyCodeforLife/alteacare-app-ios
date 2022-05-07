//
//  ChangePasswordApiImpl.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 30/04/21.
//

import Foundation
import RxSwift

class ChangePasswordApiImpl : ChangePasswordApi {
    
    private class GetResponseChangePassword : HTTPRequest {
        
        var method = HTTPMethod.POST
        var path = "/user/password/change"
        var apiVersion = ApiVersion.none
        var parameters = [String: Any]()
        var authentication = HTTPAuth.tokenType.bearer
        var header = HeaderType.basic
        
        init(body: ChangePasswordBody) {
            self.parameters = body.dictionary ?? [String:Any]()
        }
    }
    
    var httpClient: HTTPClient
    
    init(httpClient : HTTPClient) {
        self.httpClient = httpClient
    }
    
    func request(body : ChangePasswordBody) -> Single<ChangePasswordResponse> {
        return httpClient.send(request: GetResponseChangePassword(body: body))
    }
}
