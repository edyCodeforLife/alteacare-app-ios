//
//  RegisterMemberAPIImpl.swift
//  Altea Care
//
//  Created by Hedy on 06/09/21.
//

import Foundation
import RxCocoa
import RxSwift

class RegisterMemberAPIImpl: RegisterMemberAPI {
    
    private class RegisterMember: HTTPRequest {
        var method = HTTPMethod.POST
        var path = "/user/patient"
        var apiVersion = ApiVersion.none
        var parameters = [String: Any]()
        var authentication = HTTPAuth.tokenType.bearer
        var header = HeaderType.basic
        
        init(id: String, body: RegisterMemberBody) {
            self.path = "\(path)/\(id)/register"
            self.parameters = body.dictionary ?? [String: Any]()
        }
    }
    
    let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func request(id: String, body: RegisterMemberBody) -> Single<RegisterMemberResponse> {
        return httpClient.send(request: RegisterMember(id: id, body: body))
    }
}
