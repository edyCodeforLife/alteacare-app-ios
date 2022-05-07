//
//  ChangeEmailVerifyAPIImpl.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 26/07/21.
//

import Foundation
import RxCocoa
import RxSwift

class ChangeEmailVerifyAPIImpl: ChangeEmailVerifyAPI {
    
    private class GetResponseVerifyEmail: HTTPRequest {
        var method = HTTPMethod.POST
        var path = "/user/email/change"
        var apiVersion = ApiVersion.none
        var parameters = [String: Any]()
        var authentication = HTTPAuth.tokenType.bearer
        var header = HeaderType.basic
        
        init(body: ChangeEmailVerifyBody) {
            self.parameters = body.dictionary ?? [String: Any]()
        }
    }
    
    let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func requestVerifyChangeEmail(body: ChangeEmailVerifyBody) -> Single<ChangeEmailVerifyResponse> {
        return httpClient.send(request: GetResponseVerifyEmail(body: body))
    }
}
