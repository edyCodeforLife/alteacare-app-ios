//
//  AddMemberAPIImpl.swift
//  Altea Care
//
//  Created by Hedy on 12/08/21.
//

import Foundation
import RxCocoa
import RxSwift

class AddMemberAPIImpl: AddMemberAPI {
    
    private class AddMember: HTTPRequest {
        var method = HTTPMethod.POST
        var path = "/user/patient"
        var apiVersion = ApiVersion.none
        var parameters = [String: Any]()
        var authentication = HTTPAuth.tokenType.bearer
        var header = HeaderType.basic
        
        init(body: AddMemberBody) {
            self.parameters = body.dictionary ?? [String: Any]()
        }
    }
    
    let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func request(body: AddMemberBody) -> Single<AddMemberResponse> {
        return httpClient.send(request: AddMember(body: body))
    }
}
