//
//  SuccessRegisterRepository.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 03/05/21.
//

import Foundation
import RxSwift

protocol SuccessRegisterRepository {
    func requestGetUserData() -> Single<UserHomeData>
}
