//
//  AddAddressAPIImpl.swift
//  Altea Care
//
//  Created by Hedy on 12/08/21.
//

import Foundation
import RxCocoa
import RxSwift

class AddAddressAPIImpl: AddAddressAPI {
    
    private class AddAddress: HTTPRequest {
        var method = HTTPMethod.POST
        var path = "/user/address"
        var apiVersion = ApiVersion.none
        var parameters = [String: Any]()
        var authentication = HTTPAuth.tokenType.bearer
        var header = HeaderType.basic
        
        init(body: AddAddressBody) {
            self.parameters = body.dictionary ?? [String: Any]()
        }
    }
    
    let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func request(body: AddAddressBody) -> Single<AddAddressResponse> {
        return httpClient.send(request: AddAddress(body: body))
    }
}
