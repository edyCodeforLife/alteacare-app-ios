//
//  RegistrationChangeEmailAPIImpl.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 23/04/21.
//

import Foundation
import RxSwift

//MARK: - Implementation change email api 
class RegistrationChangeEmailAPIImpl: RegistrationChangeEmailAPI {

    private class GetRegistrationChangeEmailData: HTTPRequest {
        var method = HTTPMethod.POST
        var path = "/user/email/change/register"
        var apiVersion = ApiVersion.none
        var parameters = [String: Any]()
        var authentication = HTTPAuth.tokenType.bearer
        var header = HeaderType.basic
        
        init(body: [String : Any]) {
            self.parameters =  body
        }
    }
    
    let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func request(body: [String : Any]) -> Single<RegistrationChangeEmailResponse> {
        return httpClient.send(request: GetRegistrationChangeEmailData(body: body))
    }
}
