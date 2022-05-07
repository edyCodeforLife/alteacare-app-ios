//
//  ChangePhoneNumberAPI.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 10/05/21.
//

import Foundation
import RxSwift

protocol ChangePhoneNumberAPI : ClientAPI {
    func requestChangePhoneNumber(body : ChangePhoneNumberBody) -> Single<ChangePhoneNumberResponse>
}
