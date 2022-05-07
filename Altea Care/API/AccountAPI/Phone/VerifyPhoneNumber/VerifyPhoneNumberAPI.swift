//
//  VerifyPhoneNumberAPI.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 10/05/21.
//

import Foundation
import RxSwift

protocol VerifyPhoneNumberAPI : ClientAPI {
    func requestVerifyPhoneNumber(body : VerifyPhoneNumberBody) -> Single<VerifyPhoneNumberResponse>
}
