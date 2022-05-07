//
//  SendMessageAPIImpl.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 20/06/21.
//

import Foundation
import RxSwift

class SendMessageAPIImpl : SendMessageAPI{
    
    private class SendMessage : HTTPRequest {
        var method = HTTPMethod.POST
        var path = "/data/messages"
        var apiVersion = ApiVersion.none
        var parameters = [String: Any]()
        var authentication = HTTPAuth.tokenType.basic
        var header = HeaderType.basic
        
        init(body : SendMessageBody) {
            self.parameters = body.dictionary ?? [String:Any]()
        }
    }
    
    let httpClient: HTTPClient
    
    init(httpClient : HTTPClient) {
        self.httpClient = httpClient
    }
    
    func request(body: SendMessageBody) -> Single<SendMessageResponse> {
        return httpClient.send(request: SendMessage(body: body))
    }
}
