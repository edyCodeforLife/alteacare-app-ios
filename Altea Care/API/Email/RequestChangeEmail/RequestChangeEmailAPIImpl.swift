//
//  RequestChangeEmailAPIImpl.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 26/07/21.
//

import Foundation
import RxSwift
import RxCocoa

class RequestChangeEmailAPIImpl: RequestChangeEmailAPI {
    
    private class requestChangeEmailUser : HTTPRequest{
        var method = HTTPMethod.POST
        var path = "/user/email/change/otp"
        var apiVersion = ApiVersion.none
        var parameters = [String: Any]()
        var authentication = HTTPAuth.tokenType.bearer
        var header = HeaderType.basic
        
        init(body: RequestChangeEmailBody) {
            self.parameters = body.dictionary ?? [String:Any]()
        }
    }
    
    let httpClient : HTTPClient
    
    init(httpClient : HTTPClient) {
        self.httpClient = httpClient
    }
    
    func requestChangeEmail(body: RequestChangeEmailBody) -> Single<RequestChangeEmailResponse> {
        return httpClient.send(request: requestChangeEmailUser(body: body))
    }
}
