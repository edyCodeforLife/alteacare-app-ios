//
//  MedicalResumeAPIImpl.swift
//  Altea Care
//
//  Created by Hedy on 25/03/21.
//

import Foundation
import RxSwift

class MedicalResumeAPIImpl: MedicalResumeAPI {
    
    private class GetMedicalResume: HTTPRequest {
        var method = HTTPMethod.GET
        var path = "/appointment/detail/"
        var apiVersion = ApiVersion.none
        var parameters = [String: Any]()
        var authentication = HTTPAuth.tokenType.bearer
        var header = HeaderType.basic
        
        init(body : MedicalResumeBody) {
            self.path = "\(path)\(body.id)"
        }
    }
    
    let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func request(body: MedicalResumeBody) -> Single<DetailConsultationResponse> {
        return httpClient.send(request: GetMedicalResume(body: body))
    }
}
