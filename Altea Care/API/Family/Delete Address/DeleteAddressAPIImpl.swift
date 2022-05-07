//
//  DeleteAddressAPIImpl.swift
//  Altea Care
//
//  Created by Hedy on 12/08/21.
//

import Foundation
import RxCocoa
import RxSwift

class DeleteAddressAPIImpl: DeleteAddressAPI {
    
    private class DeleteAddress: HTTPRequest {
        var method = HTTPMethod.DELETE
        var path = "/user/address"
        var apiVersion = ApiVersion.none
        var parameters = [String: Any]()
        var authentication = HTTPAuth.tokenType.bearer
        var header = HeaderType.basic
        
        init(body: DeleteAddressBody) {
            self.path = "\(path)/\(body.id)"
            self.parameters = body.dictionary ?? [String: Any]()
        }
    }
    
    let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func request(body: DeleteAddressBody) -> Single<DeleteAddressResponse> {
        return httpClient.send(request: DeleteAddress(body: body))
    }
}
