//
//  ConsultationReviewAPIImpl.swift
//  Altea Care
//
//  Created by Hedy on 22/03/21.
//

import Foundation
import RxSwift

class ConsultationReviewAPIImpl: ConsultationReviewAPI {
    
    private class GetConsultationReview: HTTPRequest {
        var method = HTTPMethod.GET
        var path = "/consultation/review/"
        var apiVersion = ApiVersion.none
        var parameters = [String: Any]()
        var authentication = HTTPAuth.tokenType.basic
        var header = HeaderType.basic
        
        init(id: String) {
            self.path = "\(path)id"
        }
    }
    
    let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func request(id: String) -> Single<ConsultationReviewResponse> {
        return httpClient.send(request: GetConsultationReview(id: id))
    }
}
