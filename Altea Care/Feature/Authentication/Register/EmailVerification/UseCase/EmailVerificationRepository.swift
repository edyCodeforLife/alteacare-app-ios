//
//  EmailVerificationRepository.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 17/03/21.
//

import Foundation
import RxSwift

protocol EmailVerificationRepository {
    func requestVerifyEmail(body : VerifyEmailBody, type: String) -> Single<EmailVerificationModel?>
    func requestNewOtp(body : SendVerificationEmailBody, type: String) -> Single<SendVerificationEmailModel>
}
