//
//  ListDoctorAPIImpl.swift
//  Altea Care
//
//  Created by Rahmad Hidayat on 03/05/21.
//

import Foundation
import RxSwift

class ListDoctorAPIImpl: ListDoctorAPI {
    
    private class GetDoctors: HTTPRequest {
        var method = HTTPMethod.GET
        var path = "/data/doctors"
        var apiVersion = ApiVersion.none
        var parameters = [String: Any]()
        var authentication = HTTPAuth.tokenType.bearer
        var header = HeaderType.basic
        
        init(){
            self.path = "\(path)"
        }
    }
    
    private class GetDoctorsBySpecialization: HTTPRequest {
        var method = HTTPMethod.GET
        var path = "/data/doctors"
        var apiVersion = ApiVersion.none
        var parameters = [String: Any]()
        var authentication = HTTPAuth.tokenType.bearer
        var header = HeaderType.basic
        
        init(body: ListDoctorSpecializationBody){
            self.path = "\(path)"
            self.parameters = body.dictionary ?? [String: Any]()
        }
        
        init(body: DoctorsSpecializationBody){
            self.path = "\(path)"
            self.parameters = body.dictionary ?? [String: Any]()
        }
    }
    
    let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func requestDoctorList() -> Single<ListDoctorResponse> {
        return httpClient.send(request: GetDoctors())
    }
    
    func requestDoctorSpecializationList(id: String, day: String?, q: String) -> Single<ListDoctorResponse> {
        return httpClient.send(request: GetDoctorsBySpecialization(body: ListDoctorSpecializationBody(id: id, available_day: day, query: q)))
    }
    
    func requestDoctorSpecialization(body: DoctorsSpecializationBody) -> Single<ListDoctorResponse> {
        return httpClient.send(request: GetDoctorsBySpecialization(
            body: body))

    }
}
