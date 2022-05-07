//
//  ReverificationEmailRepository.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 17/03/21.
//

import Foundation
import RxSwift

protocol ReverificationEmailRepository {
    func requestNewOtpChangePassword(body : RequestForgotPasswordBody) -> Single<ForgotPasswordModel>
    
    func requestVerifyForgotPassword(body : VerifyOTPForgotPasswordBody) -> Single<ReverificationEmailModel>
}
