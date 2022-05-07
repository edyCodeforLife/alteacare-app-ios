//
//  ChangePasswordRepository.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 17/03/21.
//

import Foundation
import RxSwift

protocol ChangePasswordRepository {
    func requestChangePassword(body : ChangePasswordBody) -> Single<ChangePasswordModel>
}
