//
//  CheckEmailRegisterAPIImpl.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 23/08/21.
//

import Foundation
import RxCocoa
import RxSwift

class CheckEmailRegisterAPIImpl : CheckEmailRegisterAPI {
  
    private class GetCheckEmailRegister : HTTPRequest{
        var method = HTTPMethod.POST
        var path = "/user/users/check-user"
        var parameters = [String : Any]()
        var apiVersion = ApiVersion.none
        var authentication = HTTPAuth.tokenType.basic
        var header = HeaderType.basic
        
        init(body: CheckEmailRegisterBody) {
            self.parameters = body.dictionary ?? [String: Any]()
        }
    }
    
    let httpClient : HTTPClient
    
    init(httpClient : HTTPClient) {
        self.httpClient = httpClient
    }
    
    func requestCheckEmailRegister(body: CheckEmailRegisterBody) -> Single<CheckEmailRegisterResponse> {
        return httpClient.send(request: GetCheckEmailRegister(body: body))
    }
}
