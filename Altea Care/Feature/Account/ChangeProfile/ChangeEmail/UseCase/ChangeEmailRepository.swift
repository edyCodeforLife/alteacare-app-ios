//
//  ChangeEmailRepository.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 21/07/21.
//

import Foundation
import RxSwift
import RxCocoa

protocol ChangeEmailRepository {
    func requestChangeEmail(body : RequestChangeEmailBody) -> Single<ChangeEmailModel>
}
