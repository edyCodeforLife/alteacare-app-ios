//
//  CreateConsultationAPIImpl.swift
//  Altea Care
//
//  Created by Rahmad Hidayat on 31/05/21.
//

import Foundation
import RxSwift

class CreateConsultationAPIImpl: CreateConsultationAPI {
    
    private class PostConsultations: HTTPRequest {
        var method = HTTPMethod.POST
        var path = "/appointment/v2/make-consultation"
        var parameters = [String: Any]()
        var apiVersion = ApiVersion.none
        var authentication = HTTPAuth.tokenType.bearer
        var header = HeaderType.basic
        
        init(parameters: [String: Any]) {
            self.path = "\(self.path)"
            self.parameters = parameters
        }
        
    }
    
    var httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func request(parameters: [String: Any]) -> Single<CreateConsultationResponse> {
        return httpClient.send(request: PostConsultations(parameters: parameters))
    }
}
