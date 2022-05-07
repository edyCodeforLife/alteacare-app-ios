//
//  UserCancelAPIImpl.swift
//  Altea Care
//
//  Created by Hedy on 29/12/21.
//

import Foundation
import RxSwift

class UserCancelAPIImpl: UserCancelAPI {
    
    let httpClient: HTTPClient
    
    private class PostUserCancel: HTTPRequest {
        var method = HTTPMethod.POST
        var path = "/appointment/v1/consultation/cancel-by-user"
        var parameters = [String: Any]()
        var apiVersion = ApiVersion.none
        var authentication = HTTPAuth.tokenType.bearer
        var header =  HeaderType.basic
        
        init(body: [String: Any]) {
            self.parameters = body
        }
    }
    
    init(httpClient : HTTPClient) {
        self.httpClient = httpClient
    }
    
    func requestCancel(body: [String: Any]) -> Single<UserCancelResponse> {
        return httpClient.send(request: PostUserCancel(body: body))
    }
}
