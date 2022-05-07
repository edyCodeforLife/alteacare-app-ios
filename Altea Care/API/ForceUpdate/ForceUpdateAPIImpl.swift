//
//  ForceUpdateAPIImpl.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 15/09/21.
//

import Foundation
import RxSwift
import RxCocoa

class ForceUpdateAPIImpl : ForceUpdateAPI {
    
    private class getForceUpdate : HTTPRequest {
        var method = HTTPMethod.GET
        var path = "/data/version-applications"
        var apiVersion = ApiVersion.none
        var parameters = [String: Any]()
        var authentication = HTTPAuth.tokenType.bearer
        var header = HeaderType.basic
        
        init() {
            
        }
    }
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func requestForceUpdate() -> Single<ForceUpdateResponse> {
        return httpClient.send(request: getForceUpdate())
    }
    
    var httpClient: HTTPClient
    
    
}
