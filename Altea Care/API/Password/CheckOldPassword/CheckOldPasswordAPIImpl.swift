//
//  CheckOldPasswordAPIImpl.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 10/05/21.
//

import Foundation
import RxSwift

class CheckOldPasswordAPIImpl : CheckOldPasswordAPI {
    
    private class CheckOldRequest: HTTPRequest {
        var method = HTTPMethod.POST
        var path = "/user/password/check"
        var apiVersion = ApiVersion.none
        var parameters : [String: Any]
        var authentication = HTTPAuth.tokenType.basic
        var header = HeaderType.basic
        
        init(body : CheckOldPasswordBody) {
            self.parameters = body.dictionary ?? [String : Any]()
        }
    }
    
    let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func request(body : CheckOldPasswordBody) -> Single<CheckOldPasswordResponse> {
        return httpClient.send(request: CheckOldRequest(body: body))
    }
    
}
