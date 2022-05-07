//
//  EditAddressAPIImpl.swift
//  Altea Care
//
//  Created by Hedy on 12/08/21.
//

import Foundation
import RxCocoa
import RxSwift

class EditAddressAPIImpl: EditAddressAPI {
    
    private class EditAddress: HTTPRequest {
        var method = HTTPMethod.POST
        var path = "/user/address"
        var apiVersion = ApiVersion.none
        var parameters = [String: Any]()
        var authentication = HTTPAuth.tokenType.bearer
        var header = HeaderType.basic
        
        init(id: String, body: EditAddressBody) {
            self.path = "\(path)/\(id)"
            self.parameters = body.dictionary ?? [String: Any]()
        }
    }
    
    let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func request(id: String, body: EditAddressBody) -> Single<EditAddressResponse> {
        return httpClient.send(request: EditAddress(id: id, body: body))
    }
}
