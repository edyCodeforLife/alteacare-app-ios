//
//  ChangeEmailAddressRepository.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 15/03/21.
//

import Foundation
import RxSwift

protocol ChangeEmailAddressRepository {
    func requestChangeEmail(body : RegistrationChangeEmailBody) -> Single<ChangeEmailAddressModel>
}
