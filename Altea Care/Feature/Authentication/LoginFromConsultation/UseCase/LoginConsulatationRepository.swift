//
//  LoginConsulatationRepository.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 04/05/21.
//

import Foundation
import RxSwift

protocol LoginConsulatationRepository {
//    func requestLogout() -> Single<LogoutModel?>
    func requestLogin(body: LoginBody) -> Single<LoginModel>
    func requestGetUserData() -> Single<UserHomeData>
}
