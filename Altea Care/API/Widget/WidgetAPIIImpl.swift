//
//  WidgetAPIIImpl.swift
//  Altea Care
//
//  Created by Galang Aji Susanto on 29/12/21.
//

import RxSwift

class WidgetAPIImpl: WidgetAPI {
    
    
    var httpClient: HTTPClient
    
    private class GetWidget: HTTPRequest {
        var method = HTTPMethod.GET
        var path = "/data/widgets"
        var parameters = [String: Any]()
        var apiVersion = ApiVersion.none
        var authentication = HTTPAuth.tokenType.basic
        var header =  HeaderType.basic
        
    }
    
    init(httpClient : HTTPClient) {
        self.httpClient = httpClient
    }
    func getWidgets() -> Single<WidgetResponse> {
        return httpClient.send(request: GetWidget())
        
    }
}
