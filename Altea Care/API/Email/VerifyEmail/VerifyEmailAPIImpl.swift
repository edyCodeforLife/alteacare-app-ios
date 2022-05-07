//
//  VerifyEmailAPIImpl.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 23/04/21.
//

import Foundation
import RxSwift
import RxCocoa

//MARK: - Implementation API
class VerifyEmailAPIImpl: VerifyEmailAPI {
    
    private class GetResponseVerifyEmail: HTTPRequest {
        var method = HTTPMethod.POST
        var path = "/user/email/verify"
        var apiVersion = ApiVersion.none
        var parameters = [String: Any]()
        var authentication = HTTPAuth.tokenType.basic
        var header = HeaderType.basic
        
        init(body: [String : Any], type: String) {
            self.parameters = body
            self.path = "/user/\(type)/verify"
        }
    }
    
    let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func request(body: [String : Any], type: String) -> Single<VerifyEmailResponse> {
        return httpClient.send(request: GetResponseVerifyEmail(body: body, type: type))
    }
}
