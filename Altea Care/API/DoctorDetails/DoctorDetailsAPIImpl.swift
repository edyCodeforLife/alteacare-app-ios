//
//  DoctorDetailsAPIImpl.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 17/05/21.
//

import Foundation
import RxSwift

class DoctorDetailsAPIImpl: DoctorDetailsAPI {
    
    let httpClient: HTTPClient
    
    private class getDoctors : HTTPRequest{
        var method = HTTPMethod.GET
        var path = "/data/doctors/"
        var parameters = [String : Any]()
        var apiVersion = ApiVersion.none
        var authentication = HTTPAuth.tokenType.bearer
        var header = HeaderType.basic
        
        init(id : String) {
            self.path = "\(path)\(id)"
//            let params = ["id" : id]
//            self.parameters = params
        }
    }
    
    init(httpClient : HTTPClient) {
        self.httpClient = httpClient
    }
    
    func requestDoctorDetails(id: String) -> Single<DoctorDetailsResponse> {
        return httpClient.send(request: getDoctors(id: id))
    }
    
}

