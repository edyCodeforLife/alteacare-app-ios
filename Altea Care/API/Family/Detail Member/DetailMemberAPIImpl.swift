//
//  DetailMemberAPIImpl.swift
//  Altea Care
//
//  Created by Hedy on 12/08/21.
//

import Foundation
import RxCocoa
import RxSwift

class DetailMemberAPIImpl: DetailMemberAPI {
    
    private class GetMember: HTTPRequest {
        var method = HTTPMethod.GET
        var path = "/user/patient"
        var apiVersion = ApiVersion.none
        var parameters = [String: Any]()
        var authentication = HTTPAuth.tokenType.bearer
        var header = HeaderType.basic
        
        init(body: DetailMemberBody) {
            self.path = "\(path)/\(body.id)"
            self.parameters = [String: Any]()
        }
    }
    
    let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func request(body: DetailMemberBody) -> Single<DetailMemberResponse> {
        return httpClient.send(request: GetMember(body: body))
    }
}
