//
//  ListConsultationAPIImpl.swift
//  Altea Care
//
//  Created by Hedy on 22/03/21.
//

import Foundation
import RxSwift

class ListConsultationAPIImpl: ListConsultationAPI {
    
    private class GetConsultations: HTTPRequest {
        var method = HTTPMethod.POST
        var path = "/appointment"
        var apiVersion = ApiVersion.none
        var parameters: [String: Any]
        var authentication = HTTPAuth.tokenType.bearer
        var header = HeaderType.basic
        
        init(parameters: [String: Any], type: ListConsultationType) {
            self.path = "\(self.path)/\(type.rawValue)"
            self.parameters = parameters
        }
    }
    
    let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func request(parameters: [String: Any], type: ListConsultationType) -> Single<ListConsultationResponse> {
        
        return httpClient.send(request: GetConsultations(parameters: parameters, type: type))
    }
    
}
