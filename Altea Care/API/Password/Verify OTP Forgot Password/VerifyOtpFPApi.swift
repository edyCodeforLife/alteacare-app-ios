//
//  VerifyOTPFPApi.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 30/04/21.
//

import Foundation
import RxSwift

protocol VerifyOtpFPApi : ClientAPI {
    func request(parameters : [String : Any]) -> Single<VerifyOtpFPResponse>
}
