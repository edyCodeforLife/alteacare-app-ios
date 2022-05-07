//
//  VerifyOtpApiImpl.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 30/04/21.
//

import Foundation
import RxSwift

class VerifyOtpApiImpl : VerifyOtpFPApi {
    
    private class GetResponseVerifyOtp : HTTPRequest {
        
        var method = HTTPMethod.POST
        var path = "/user/password/verify"
        var apiVersion = ApiVersion.none
        var parameters = [String: Any]()
        var authentication = HTTPAuth.tokenType.bearer
        var header = HeaderType.basic
        
        init(parameters : [String : Any]) {
          self.parameters = parameters
        }
    }
    
    var httpClient: HTTPClient
    
    init(httpClient : HTTPClient) {
        self.httpClient = httpClient
    }
    
    func request(parameters: [String : Any]) -> Single<VerifyOtpFPResponse> {
        return httpClient.send(request: GetResponseVerifyOtp(parameters: parameters))
    }
}
