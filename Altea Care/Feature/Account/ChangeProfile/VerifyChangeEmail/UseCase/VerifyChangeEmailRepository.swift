//
//  VerifyChangeEmailRepository.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 26/07/21.
//

import Foundation
import RxSwift

protocol VerifyChangeEmailRepository {
    func requestVerifyChangeEmail(body : ChangeEmailVerifyBody) -> Single<VerifyChangeEmailModel>
}

