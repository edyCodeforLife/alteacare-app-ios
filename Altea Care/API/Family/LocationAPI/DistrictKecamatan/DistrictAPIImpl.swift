//
//  DistrictAPIImpl.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 01/09/21.
//

import Foundation
import RxSwift
import RxCocoa

class DistrictAPIImpl : DistrictAPI{
    
    private class GetDistrict : HTTPRequest{
        var method = HTTPMethod.GET
        var path = "/data/districts?"
        var apiVersion = ApiVersion.none
        var parameters = [String: Any]()
        var authentication = HTTPAuth.tokenType.basic
        var header = HeaderType.basic
        
        init(id: String) {
            let params = ["city" : id]
            self.path = "\(path)"
            self.parameters = params
//            self.parameters = body.dictionary ?? [String: Any]()
        }
    }
    
    let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func requestDistrict(body: DistrictBody) -> Single<DistrictResponse> {
        return httpClient.send(request: GetDistrict(id: body.id))
    }
}
