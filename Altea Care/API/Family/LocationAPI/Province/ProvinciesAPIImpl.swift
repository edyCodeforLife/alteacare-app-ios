//
//  ProvinciesAPIImpl.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 01/09/21.
//

import Foundation
import RxSwift
import RxCocoa

class ProvinciesAPIImpl : ProvinciesAPI {
    
    private class GetProvincies : HTTPRequest {
        var method = HTTPMethod.GET
        var path = "/data/provinces?"
        var apiVersion = ApiVersion.none
        var parameters = [String: Any]()
        var authentication = HTTPAuth.tokenType.basic
        var header = HeaderType.basic
        
        init(id : String) {
            let params = ["country" : id]
            self.path = "\(path)"
            self.parameters = params
//            self.parameters = body.dictionary ?? [String: Any]()
        }
    }
    
    let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func requestProvincies(body : ProvinciesBody) -> Single<ProvinciesResponse> {
        return httpClient.send(request: GetProvincies(id: body.id))
    }
}
