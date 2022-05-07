//
//  TermAndConditionRepository.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 17/03/21.
//

import Foundation
import RxSwift

protocol TermAndConditionRepository {
    func requestRegister(body : RegisterBody) -> Single<RegisterModel?>
    
    func requestSendVerificationEmail(body : SendVerificationEmailBody) -> Single<SendVerificationEmailModel>
    
    func requestTermCondition() -> Single<TermAndConditionModel>
}
