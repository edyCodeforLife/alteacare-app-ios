//
//  DoctorScheduleAPIImpl.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 17/05/21.
//

import Foundation
import RxSwift

class DoctorScheduleAPIImpl : DoctorScheduleAPI {
    
    let httpClient: HTTPClient
    
    private class getDoctorSchedules : HTTPRequest{
        var method = HTTPMethod.GET
        var path = "/data/doctor-schedules"
        var parameters = [String : Any]()
        var apiVersion = ApiVersion.none
        var authentication = HTTPAuth.tokenType.basic
        var header = HeaderType.basic
        
        init(id : String, date : String) {
            self.path = "\(path)"
            let params = [
                "doctor_id":id,
                "date": date
            ]
            self.parameters = params
        }
    }
    
    init(httpClient : HTTPClient) {
        self.httpClient = httpClient
    }
    
    func request(id : String, date : String) -> Single<DoctorScheduleResponse> {
        return httpClient.send(request: getDoctorSchedules(id: id, date: date))
    }
}
