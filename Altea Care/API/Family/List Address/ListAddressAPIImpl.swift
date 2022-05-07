//
//  ListAddressAPIImpl.swift
//  Altea Care
//
//  Created by Hedy on 12/08/21.
//

import Foundation
import RxCocoa
import RxSwift

class ListAddressAPIImpl: ListAddressAPI {
    
    private class GetListAddress: HTTPRequest {
        var method = HTTPMethod.GET
        var path = "/user/address"
        var apiVersion = ApiVersion.none
        var parameters = [String: Any]()
        var authentication = HTTPAuth.tokenType.bearer
        var header = HeaderType.basic
        
//        init(body: ListAddressBody) {
//            self.parameters = body.dictionary ?? [String: Any]()
//        }
        init() {
            self.path = "\(path)"
        }
    }
    
    let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func request() -> Single<ListAddressResponse> {
        return httpClient.send(request: GetListAddress())
    }
}
