//
//  ListHospitalAPIImpl.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 17/09/21.
//

import Foundation
import RxSwift
import RxCocoa

class ListHospitalAPIImpl : ListHospitalAPI {
    
    private class getListHospital : HTTPRequest {
        var method = HTTPMethod.GET
        var path = "/data/hospitals"
        var apiVersion = ApiVersion.none
        var parameters = [String: Any]()
        var authentication = HTTPAuth.tokenType.basic
        var header = HeaderType.basic
        
        init() {
            
        }
    }
    
    var httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func requestListHospital() -> Single<ListHospitalResponse> {
        return httpClient.send(request: getListHospital())
    }
    
}
