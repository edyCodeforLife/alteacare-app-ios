//
//  DefaultMemberAPIImpl.swift
//  Altea Care
//
//  Created by Tiara on 03/09/21.
//

import Foundation
import RxSwift

class DefaultMemberAPIImpl : DefaultMemberAPI {
    var httpClient: HTTPClient
    
    private class GetDefaultMember : HTTPRequest {
        var method = HTTPMethod.GET
        var path = "/user/patient"
        var apiVersion = ApiVersion.none
        var parameters = [String: Any]()
        var authentication = HTTPAuth.tokenType.bearer
        var header = HeaderType.basic
        
        init(body: SetDefaultMemberBody) {
            self.path = "\(path)/\(body.id)/set-default"
        }
    }
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func requestSetAsDefault(body: SetDefaultMemberBody) -> Single<SetDefaultMemberResponse> {
        return httpClient.send(request: GetDefaultMember(body: body))
    }
}
