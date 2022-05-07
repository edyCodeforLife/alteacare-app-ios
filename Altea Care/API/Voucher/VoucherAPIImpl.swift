//
//  VoucherAPIImpl.swift
//  Altea Care
//
//  Created by Tiara on 11/09/21.
//

import Foundation
import RxSwift

class VoucherAPIImpl: VoucherAPI {
    
    let httpClient: HTTPClient
    
    private class GetVoucher : HTTPRequest{
        var method = HTTPMethod.POST
        var path = "/payment/voucher/check/"
        var parameters = [String : Any]()
        var apiVersion = ApiVersion.none
        var authentication = HTTPAuth.tokenType.bearer
        var header = HeaderType.basic
        
        init(body : VoucherBody) {
            self.parameters = body.dictionary ?? [String: Any]()
        }
    }
    
    init(httpClient : HTTPClient) {
        self.httpClient = httpClient
    }
    
    func request(body: VoucherBody) -> Single<VoucherResponse> {
        return httpClient.send(request: GetVoucher(body: body))
    }
    
}
