//
//  ChatHistoryAPIImpl.swift
//  Altea Care
//
//  Created by Hedy on 22/03/21.
//

import Foundation
import RxSwift

class ChatHistoryAPIImpl: ChatHistoryAPI {
    
    private class GetChatHistory: HTTPRequest {
        var method = HTTPMethod.POST
        var path = "/chat/history"
        var apiVersion = ApiVersion.none
        var parameters: [String: Any]
        var authentication = HTTPAuth.tokenType.basic
        var header = HeaderType.basic
        
        init(parameters: [String: Any]) {
            self.parameters = parameters
        }
    }
    
    let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func request(parameters: [String: Any]) -> Single<ChatHistoryResponse> {
        return httpClient.send(request: GetChatHistory(parameters: parameters))
    }
}
