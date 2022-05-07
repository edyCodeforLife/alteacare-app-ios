//
//  CountryAPIImpl.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 07/05/21.
//

import Foundation
import RxSwift

class CountryAPIImpl : CountryAPI {
    
    var httpClient: HTTPClient
    
    private class GetCountry : HTTPRequest {
        var method = HTTPMethod.GET
        var path = "/data/countries/"
        var apiVersion = ApiVersion.none
        var parameters = [String: Any]()
        var authentication = HTTPAuth.tokenType.basic
        var header = HeaderType.basic
        
        init() {
            let params = ["_limit" : 1000]
            self.parameters = params
            self.path = "\(path)"
        }
    }
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func request() -> Single<CountryResponse> {
        return httpClient.send(request: GetCountry())
    }
}
