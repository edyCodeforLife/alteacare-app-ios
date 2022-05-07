//
//  DetailConsultationAPIImpl.swift
//  Altea Care
//
//  Created by Hedy on 22/03/21.
//

import Foundation
import RxSwift

class DetailConsultationAPIImpl: DetailConsultationAPI {
    
    private class GetConsultation: HTTPRequest {
        var method = HTTPMethod.GET
        var path = "/appointment/detail/"
        var apiVersion = ApiVersion.none
        var parameters = [String: Any]()
        var authentication = HTTPAuth.tokenType.bearer
        var header = HeaderType.basic
        
        init(id: String) {
            self.path = "\(path)\(id)"
        }
    }
    
    let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func request(id: String) -> Single<DetailConsultationResponse> {
        return httpClient.send(request: GetConsultation(id: id))
    }
}
