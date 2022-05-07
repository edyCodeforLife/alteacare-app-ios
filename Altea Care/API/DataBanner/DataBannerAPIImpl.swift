//
//  DataBannerResponse.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 01/07/21.
//

import Foundation
import RxSwift

class DataBannerAPIImpl : DataBannerAPI {
    
    let httpClient: HTTPClient
    
    private class getDataBanner : HTTPRequest{
        
        var method = HTTPMethod.GET
        var path = "/data/banners"
        var parameters = [String : Any]()
        var apiVersion = ApiVersion.none
        var authentication = HTTPAuth.tokenType.basic
        var header = HeaderType.basic
        
        init(category: BannerCategory){
            self.parameters = ["category": category.rawValue]
        }
    }
    
    init(httpClient : HTTPClient) {
        self.httpClient = httpClient
    }
    
    func requestBanner(category: BannerCategory) -> Single<DataBannerResponse> {
        return httpClient.send(request: getDataBanner(category: category))
    }
}
