//
//  VerifyPhoneNumberAPIImpl.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 10/05/21.
//

import Foundation
import RxSwift

class VerifyPhoneNumberAPIImpl : VerifyPhoneNumberAPI {
    
    
    private class RequestVerifyPhoneNumber : HTTPRequest {
        var method = HTTPMethod.POST
        var path = "/user/phone/verify"
        var apiVersion = ApiVersion.none
        var parameters = [String: Any]()
        var authentication = HTTPAuth.tokenType.bearer
        var header = HeaderType.basic
        
        init(body : VerifyPhoneNumberBody) {
            self.parameters = body.dictionary ?? [String : Any]()
        }
    }
    
    let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func requestVerifyPhoneNumber(body: VerifyPhoneNumberBody) -> Single<VerifyPhoneNumberResponse> {
        return httpClient.send(request: RequestVerifyPhoneNumber(body: body))
    }
}
