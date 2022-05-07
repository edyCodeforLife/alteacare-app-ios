//
//  SymptomAPIImpl.swift
//  Altea Care
//
//  Created by Galang Aji Susanto on 18/11/21.
//

import Foundation
import RxSwift

class ListSymptomAPIImpl: ListSymptomAPI {
    
    let httpClient: HTTPClient
    
    private class GetSymptomSearch: HTTPRequest {
        var method = HTTPMethod.GET
        var path = "/data/symtoms"
        var parameters = [String: Any]()
        var apiVersion = ApiVersion.none
        var authentication = HTTPAuth.tokenType.bearer
        var header =  HeaderType.basic
        
        init(_ body: ListSymptomBody) {
            self.parameters = body.dictionary ?? [String:Any]()
        }
    }
    
    init(httpClient : HTTPClient) {
        self.httpClient = httpClient
    }
    
    func requestSymptomListSearch(body: ListSymptomBody) -> Single<ListSymptomResponse> {
        return httpClient.send(request: GetSymptomSearch(body) )
    }
}
