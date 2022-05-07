//
//  ListSpecialistAPIImpl.swift
//  Altea Care
//
//  Created by Rahmad Hidayat on 11/05/21.
//

import Foundation
import RxSwift

class ListSpecialistAPIImpl: ListSpecialistAPI {
    
    private class GetSpecialist: HTTPRequest {
        var method = HTTPMethod.GET
        var path = "/data/specializations"
        var parameters = [String: Any]()
        var apiVersion = ApiVersion.none
        var authentication = HTTPAuth.tokenType.bearer
        var header =  HeaderType.basic
        
        init(q: String) {
            self.path = "\(path)"
            let params = [
                "_q" : q
            ]
            self.parameters = params
        }
        
        init(req: SpecializationsRequest) {
            self.path = "\(path)"
            if req.id != nil && req._q != nil && req._limit != nil && req._page != nil && req.is_popular != nil{
                let params = [
                    "id" : req.id,
                    "_q" : req._q,
                    "_limit" : req._limit,
                    "_page" : req._page,
                    "is_popular" : req.is_popular
                ]
                
                self.parameters = params
            }            
        }
    }
    
    private class GetSpecialistPopular: HTTPRequest {
        var method = HTTPMethod.GET
        var path = "/data/specializations"
        var parameters = [String: Any]()
        var apiVersion = ApiVersion.none
        var authentication = HTTPAuth.tokenType.bearer
        var header =  HeaderType.basic
        
        init() {
            self.path = "\(path)"
            let params = ["is_popular": "YES"]
            self.parameters = params
        }
    }
    
    var httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func requestSpecializations(_ req: SpecializationsRequest) -> Single<ListSpecialistResponse> {
        return httpClient.send(request: GetSpecialist(req: req))
    }
    
    func requestSpecialistList(_ q: String) -> Single<ListSpecialistResponse> {
        return httpClient.send(request: GetSpecialist(q: q))
    }
    
    func requestSpecialistPopular() -> Single<ListSpecialistResponse> {
        return httpClient.send(request: GetSpecialistPopular())
    }
}




