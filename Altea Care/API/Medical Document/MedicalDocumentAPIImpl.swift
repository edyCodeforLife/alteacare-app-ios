//
//  MedicalDocumentAPIImpl.swift
//  Altea Care
//
//  Created by Hedy on 25/03/21.
//

import Foundation
import RxSwift

class MedicalDocumentAPIImpl: MedicalDocumentAPI {
    
    private class GetMedicalDocument: HTTPRequest {
        var method = HTTPMethod.GET
        var path = "/appointment/detail/"
        var apiVersion = ApiVersion.none
        var parameters = [String: Any]()
        var authentication = HTTPAuth.tokenType.bearer
        var header = HeaderType.basic
        
        init(body : MedicalDocumentBody) {
            self.path = "\(path)\(body.id)"
        }
    }
    
    let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func request(body: MedicalDocumentBody) -> Single<DetailConsultationResponse> {
        return httpClient.send(request: GetMedicalDocument(body: body))
    }
}
