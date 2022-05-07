//
//  ListMemberAPIImpl.swift
//  Altea Care
//
//  Created by Hedy on 12/08/21.
//

import Foundation
import RxCocoa
import RxSwift

class ListMemberAPIImpl: ListMemberAPI {
    
    private class GetListMember: HTTPRequest {
        var method = HTTPMethod.GET
        var path = "/user/patient"
        var apiVersion = ApiVersion.none
        var parameters = [String: Any]()
        var authentication = HTTPAuth.tokenType.bearer
        var header = HeaderType.basic
        
        init() {
            self.path = "\(path)"
//            self.parameters = body.dictionary ?? [String: Any]()
        }
    }
    
    let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func request() -> Single<ListMemberResponse> {
        return httpClient.send(request: GetListMember())
    }
}
