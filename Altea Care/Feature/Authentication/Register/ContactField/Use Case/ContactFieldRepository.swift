//
//  ContactFieldRepository.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 15/03/21.
//

import Foundation
import RxSwift

protocol ContactFieldRepository {
    func requestCheckEmailRegister(body : CheckEmailRegisterBody) -> Single<CheckEmailRegisterModel?>
}
