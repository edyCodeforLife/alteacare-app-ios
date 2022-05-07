//
//  SendVerificationEmailAPIImpl.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 23/04/21.
//

import Foundation
import RxSwift

//MARK: - Implementation of Verificiation Email
class SendVerificationEmailAPIImpl: SendVerificationEmailAPI {
    
    private class GetSendVerificationEmailData: HTTPRequest {
        var method = HTTPMethod.POST
        var path = "/user/email/verification"
        var apiVersion = ApiVersion.none
        var parameters = [String: Any]()
        var authentication = HTTPAuth.tokenType.basic
        var header = HeaderType.basic
        
        init(parameters: [String : Any],type: String) {
            self.path = "/user/\(type)/verification"
            self.parameters = parameters
        }
    }
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    var httpClient: HTTPClient
    
    func request(parameters: [String : Any], type: String) -> Single<SendVerificationEmailResponse> {
        return httpClient.send(request: GetSendVerificationEmailData(parameters: parameters, type: type))
    }
}
