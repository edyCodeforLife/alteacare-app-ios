//
//  PrimaryAddressAPIImpl.swift
//  Altea Care
//
//  Created by Hedy on 12/08/21.
//

import Foundation
import RxCocoa
import RxSwift

class PrimaryAddressAPIImpl: PrimaryAddressAPI {
    
    private class SetPrimary: HTTPRequest {
        var method = HTTPMethod.GET
        var path = "/user/address"
        var apiVersion = ApiVersion.none
        var parameters = [String: Any]()
        var authentication = HTTPAuth.tokenType.bearer
        var header = HeaderType.basic
        
        init(body: PrimaryAddressBody) {
            self.path = "\(path)/\(body.id)/set-primary"
            self.parameters = body.dictionary ?? [String: Any]()
        }
    }
    
    let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func request(body: PrimaryAddressBody) -> Single<PrimaryAddressResponse> {
        return httpClient.send(request: SetPrimary(body: body))
    }
}
