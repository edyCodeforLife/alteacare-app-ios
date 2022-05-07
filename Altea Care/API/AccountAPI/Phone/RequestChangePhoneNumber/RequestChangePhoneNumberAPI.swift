//
//  RequestChangePhoneNumberAPI.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 10/05/21.
//

import Foundation
import RxSwift

protocol RequestChangePhoneNumberAPI : ClientAPI {
    func requestSwitchChangePhoneNumber(body : RequestChangePhoneNumberBody) -> Single<RequestChangePhoneNumberResponse>
}
