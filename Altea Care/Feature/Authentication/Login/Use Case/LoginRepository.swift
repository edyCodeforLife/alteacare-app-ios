//
//  LoginRepository.swift
//  Altea Care
//
//  Created by Hedy on 06/03/21.
//

import Foundation
import RxSwift

protocol LoginRepository {
    func requestLogin(body: LoginBody) -> Single<LoginModel>
    func requestSendVerificationEmail(body : SendVerificationEmailBody, type: String) -> Single<SendVerificationEmailModel>
}
