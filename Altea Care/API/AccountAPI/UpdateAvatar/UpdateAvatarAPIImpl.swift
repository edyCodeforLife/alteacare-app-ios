//
//  UpdateAvatarAPIImpl.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 23/07/21.
//

import Foundation
import RxSwift

class UpdateAvatarAPIImpl : UpdateAvatarAPI {
    
    private class RequestUpdateAvatar : HTTPRequest{
        var method = HTTPMethod.POST
        var path = "/user/profile/update-avatar"
        var parameters = [String : Any]()
        var apiVersion = ApiVersion.none
        var authentication = HTTPAuth.tokenType.bearer
        var header = HeaderType.basic
        
        init(body : UpdateAvatarBody ) {
            self.parameters = body.dictionary ?? [String : Any]()
        }
    }
    
    let httpClient : HTTPClient
    
    init(httpClient : HTTPClient) {
        self.httpClient = httpClient
    }
    
    func requestUpdateAvatar(body: UpdateAvatarBody) -> Single<UpdateAvatarResponse> {
        return httpClient.send(request: RequestUpdateAvatar(body: body))
    }
}
