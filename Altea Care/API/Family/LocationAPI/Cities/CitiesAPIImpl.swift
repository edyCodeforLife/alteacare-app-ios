//
//  CitiesAPIImpl.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 01/09/21.
//

import Foundation
import RxSwift
import RxCocoa

class CitiesAPIImpl: CitiesAPI {
    
    private class GetCities : HTTPRequest{
        var method = HTTPMethod.GET
        var path = "/data/cities?"
        var apiVersion = ApiVersion.none
        var parameters = [String: Any]()
        var authentication = HTTPAuth.tokenType.basic
        var header = HeaderType.basic
        
        init(id : String) {
            let params = ["province" : id]
            self.path = "\(path)"
            self.parameters = params
        }
    }
    
    let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func requestCities(body: CitiesBody) -> Single<CitiesResponse> {
        return httpClient.send(request: GetCities(id: body.id))
    }
}
