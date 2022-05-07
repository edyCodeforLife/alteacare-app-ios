//
//  FamilyRelationAPIImpl.swift
//  Altea Care
//
//  Created by Tiara on 02/09/21.
//

import Foundation
import RxSwift

class FamilyRelationAPIImpl : FamilyRelationAPI {
    
    var httpClient: HTTPClient
    
    private class GetFamilyRelation : HTTPRequest {
        var method = HTTPMethod.GET
        var path = "/data/family-relation-types"
        var apiVersion = ApiVersion.none
        var parameters = [String: Any]()
        var authentication = HTTPAuth.tokenType.basic
        var header = HeaderType.basic
        
        init() {
            self.path = "\(path)"
        }
    }
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func request() -> Single<FamilyRelationResponse> {
        return httpClient.send(request: GetFamilyRelation())
    }
}
