//
//  SubDistrictAPIImpl.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 01/09/21.
//

import Foundation
import RxCocoa
import RxSwift

class SubDistrictAPIImpl : SubDistrictAPI {
    
    private class GetSubDistrict: HTTPRequest{
        var method = HTTPMethod.GET
        var path = "/data/sub-districts?"
        var apiVersion = ApiVersion.none
        var parameters = [String: Any]()
        var authentication = HTTPAuth.tokenType.basic
        var header = HeaderType.basic
        
        init(id : String) {
            let params = ["district" : id]
            self.path = "\(path)"
            self.parameters = params
//            self.parameters = body.dictionary ?? [String: Any]()
        }
    }
    
    let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func requestSubDistrict(body : SubDistrictBody) -> Single<SubDistrictResponse> {
        return httpClient.send(request: GetSubDistrict(id: body.id))
    }
}
