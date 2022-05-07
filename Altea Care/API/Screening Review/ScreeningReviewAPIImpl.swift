//
//  ScreeningReviewAPIImpl.swift
//  Altea Care
//
//  Created by Hedy on 22/03/21.
//

import Foundation
import RxSwift

class ScreeningReviewAPIImpl: ScreeningReviewAPI {
    
    private class GetScreeningReview: HTTPRequest {
        var method = HTTPMethod.GET
        var path = "/screening/review/"
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
    
    func request(id: String) -> Single<ScreeningReviewResponse> {
        return httpClient.send(request: GetScreeningReview(id: id))
    }
}
