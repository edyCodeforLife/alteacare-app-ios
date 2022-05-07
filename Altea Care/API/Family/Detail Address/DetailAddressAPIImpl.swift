//
//  DetailAddressAPIImpl.swift
//  Altea Care
//
//  Created by Hedy on 12/08/21.
//

import Foundation
import RxCocoa
import RxSwift

class DetailAddressAPIImpl: DetailAddressAPI {
    
    private class GetAddress: HTTPRequest {
        var method = HTTPMethod.GET
        var path = "/user/address"
        var apiVersion = ApiVersion.none
        var parameters = [String: Any]()
        var authentication = HTTPAuth.tokenType.bearer
        var header = HeaderType.basic
        
        init(body: DetailAddressBody) {
            self.path = "\(path)/\(body.id)"
            self.parameters = body.dictionary ?? [String: Any]()
        }
    }
    
    let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func request(body: DetailAddressBody) -> Single<DetailAddressResponse> {
        return httpClient.send(request: GetAddress(body: body))
    }
}
