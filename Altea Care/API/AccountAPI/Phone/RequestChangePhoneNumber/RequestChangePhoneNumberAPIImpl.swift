//
//  RequestChangePhoneNumberAPIImpl.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 10/05/21.
//

import Foundation
import RxSwift

class RequestChangePhoneNumberAPIImpl : RequestChangePhoneNumberAPI {
    
    private class RequestChangePhoneNumber : HTTPRequest {
        var method = HTTPMethod.POST
        var path = "/user/phone/change/otp"
        var apiVersion = ApiVersion.none
        var parameters = [String: Any]()
        var authentication = HTTPAuth.tokenType.bearer
        var header = HeaderType.basic
        
        init(body : RequestChangePhoneNumberBody) {
            self.parameters =  body.dictionary ?? [String : Any]()
        }
    }
    
    let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func requestSwitchChangePhoneNumber(body: RequestChangePhoneNumberBody) -> Single<RequestChangePhoneNumberResponse> {
        return httpClient.send(request: RequestChangePhoneNumber(body: body))
    }
}
