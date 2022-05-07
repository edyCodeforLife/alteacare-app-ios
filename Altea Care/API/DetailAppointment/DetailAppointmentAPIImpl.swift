//
//  DetailAppointmentAPIImpl.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 06/07/21.
//

import Foundation
import RxSwift

class DetailAppointmentAPIImpl: DetailAppointmentAPI {
    
    
    private class GetDetailAppointment : HTTPRequest{
        var method = HTTPMethod.GET
        var path = "/appointment/detail/"
        var parameters = [String : Any]()
        var apiVersion = ApiVersion.none
        var authentication = HTTPAuth.tokenType.bearer
        var header = HeaderType.basic
        
        init(id: Int) {
            self.path = "\(path)\(id)"
        }
    }
    
    let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func requestDetailAppointment(body: DetailAppointmentBody) -> Single<DetailAppointmentResponse> {
        return httpClient.send(request: GetDetailAppointment(id: body.appointment_id))
    }
}
