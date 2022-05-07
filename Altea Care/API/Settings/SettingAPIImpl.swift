//
//  SettingAPIImpl.swift
//  Altea Care
//
//  Created by Galang Aji Susanto on 28/11/21.
//

import Foundation
import RxSwift


class SettingAPIImpl: SettingAPI {
    var httpClient: HTTPClient
    
    private class GetSetting: HTTPRequest {
        var method = HTTPMethod.GET
        var path = "/data/setting"
        var parameters = [String: Any]()
        var apiVersion = ApiVersion.none
        var authentication = HTTPAuth.tokenType.bearer
        var header =  HeaderType.basic
        
        init() {}
    }
    
    init(httpClient : HTTPClient) {
        self.httpClient = httpClient
    }

    func getSettings() -> Single<SettingResponse> {
        return httpClient.send(request: GetSetting())
    }
}
