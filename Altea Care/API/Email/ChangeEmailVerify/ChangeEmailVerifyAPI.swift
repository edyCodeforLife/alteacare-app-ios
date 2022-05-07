//
//  ChangeEmailVerifyAPI.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 26/07/21.
//

import Foundation
import RxCocoa
import RxSwift

protocol ChangeEmailVerifyAPI: ClientAPI {
    func requestVerifyChangeEmail(body : ChangeEmailVerifyBody) -> Single<ChangeEmailVerifyResponse>
}
