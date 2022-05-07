//
//  SearchAPIImpl.swift
//  Altea Care
//
//  Created by Rahmad Hidayat on 04/07/21.
//

import Foundation
import RxSwift

class SearchAPIImpl: SearchAPI {
    private class GetEverything: HTTPRequest{
        var method = HTTPMethod.GET
        var path = "/data/search"
        var parameters = [String: Any]()
        var apiVersion = ApiVersion.none
        var authentication = HTTPAuth.tokenType.bearer
        var header =  HeaderType.basic
        
        init(q: String) {
            self.path = "\(path)"
            var params: [String: String] = [:]
            
            if q.isEmpty {
                params = [
                    "is_popular" : "YES"
                ]
            } else {
                params = [
                    "_q" : q
                ]
            }
            self.parameters = params
        }
        
    }
    
    var httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    func requestEverything(q: String) -> Single<SearchResponse> {
        return httpClient.send(request: GetEverything(q: q))
    }
}
