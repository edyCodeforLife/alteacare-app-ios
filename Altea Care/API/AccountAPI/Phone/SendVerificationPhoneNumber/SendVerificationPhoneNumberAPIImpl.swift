//
//  SendVerificationPhoneNumberAPIImpl.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 10/05/21.
//

import Foundation
import RxSwift

class SendVerificationPhoneNumberAPIImpl : SendVerificationPhoneNumberAPI {
   
    private class RequestSendVerificationPhoneNumber: HTTPRequest {
        var method = HTTPMethod.POST
        var path = "/user/phone/verification"
        var apiVersion = ApiVersion.none
        var parameters = [String: Any]()
        var authentication = HTTPAuth.tokenType.bearer
        var header = HeaderType.basic
        
        init(body : SendVerificationPhoneNumberBody) {
            self.parameters =  body.dictionary ?? [String : Any]()
        }
    }
    
    let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func request(body : SendVerificationPhoneNumberBody) -> Single<SendVerificationPhoneNumberResponse> {
        return httpClient.send(request: RequestSendVerificationPhoneNumber(body: body))
    }
}
