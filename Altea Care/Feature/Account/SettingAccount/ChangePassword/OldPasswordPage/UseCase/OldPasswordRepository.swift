//
//  OldPasswordRepository.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 05/04/21.
//

import Foundation
import RxSwift

protocol OldPasswordRepository {
    func requestCheckOldPassword(body : CheckOldPasswordBody) -> Single<OldPasswordModel>
}
