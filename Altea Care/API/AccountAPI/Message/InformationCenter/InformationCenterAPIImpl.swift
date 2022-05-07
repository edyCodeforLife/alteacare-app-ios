//
//  InformationCenterAPIImpl.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 06/08/21.
//

import Foundation
import RxSwift

class InformationCenterAPIImpl : InformationCenterAPI {
    
    private class GetInformationCenter : HTTPRequest{
        var method = HTTPMethod.GET
        var path = "/data/contents/PUSAT_INFORMASI"
        var apiVersion = ApiVersion.none
        var parameters = [String : Any]()
        var authentication = HTTPAuth.tokenType.basic
        var header = HeaderType.basic
        
        init() {
            self.path = "\(path)"
        }
    }
    
    let httpClient: HTTPClient
    
    init(httpClient : HTTPClient) {
        self.httpClient = httpClient
    }
    
    func request() -> Single<InformationCenterResponse> {
        return httpClient.send(request: GetInformationCenter())
    }
}
