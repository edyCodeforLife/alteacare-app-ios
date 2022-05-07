//
//  UpdateMemberAPIImpl.swift
//  Altea Care
//
//  Created by Hedy on 12/08/21.
//

import Foundation
import RxCocoa
import RxSwift

class UpdateMemberAPIImpl: UpdateMemberAPI {
    
    private class UpdateMember: HTTPRequest {
        var method = HTTPMethod.POST
        var path = "/user/patient"
        var apiVersion = ApiVersion.none
        var parameters = [String: Any]()
        var authentication = HTTPAuth.tokenType.bearer
        var header = HeaderType.basic
        
        init(id: String, body: UpdateMemberBody) {
            self.path = "\(path)/\(id)"
            self.parameters = body.dictionary ?? [String: Any]()
        }
    }
    
    let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func request(id: String, body: UpdateMemberBody) -> Single<UpdateMemberResponse> {
        return httpClient.send(request: UpdateMember(id: id, body: body))
    }
}
