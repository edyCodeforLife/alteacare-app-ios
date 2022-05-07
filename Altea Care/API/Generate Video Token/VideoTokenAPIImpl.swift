//
//  VideoTokenAPIImpl.swift
//  Altea Care
//
//  Created by Hedy on 22/03/21.
//

import Foundation
import RxSwift

class VideoTokenAPIImpl: VideoTokenAPI {
    
    private class GenerateVideoToken: HTTPRequest {
        var method = HTTPMethod.GET
        var path = "/appointment/detail"
        var apiVersion = ApiVersion.none
        var parameters = [String: Any]()
        var authentication = HTTPAuth.tokenType.bearer
        var header = HeaderType.basic
        
        init(id: String) {
            self.path = "\(self.path)/\(id)/room"
            let params = ["appoinment_id":id]
            self.parameters = params
        }
    }
    
    let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func request(body: VideoTokenBody) -> Single<VideoTokenResponse> {
        return httpClient.send(request: GenerateVideoToken(id: body.appointmentId))
    }
}
