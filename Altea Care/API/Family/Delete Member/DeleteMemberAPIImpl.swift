//
//  DeleteMemberAPIImpl.swift
//  Altea Care
//
//  Created by Hedy on 12/08/21.
//

import Foundation
import RxCocoa
import RxSwift

class DeleteMemberAPIImpl: DeleteMemberAPI {
    
    private class DeleteMember: HTTPRequest {
        var method = HTTPMethod.DELETE
        var path = "/user/patient"
        var apiVersion = ApiVersion.none
        var parameters = [String: Any]()
        var authentication = HTTPAuth.tokenType.bearer
        var header = HeaderType.basic
        
        init(body: DeleteMemberBody) {
            self.path = "\(path)/\(body.id)"
            self.parameters = body.dictionary ?? [String: Any]()
        }
    }
    
    let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func request(body: DeleteMemberBody) -> Single<DeleteMemberResponse> {
        return httpClient.send(request: DeleteMember(body: body))
    }
}
