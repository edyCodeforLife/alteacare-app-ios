//
//  SendVerificationEmailAPI.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 23/04/21.
//

import Foundation
import RxSwift

//MARK: - Func send verification email
protocol SendVerificationEmailAPI : ClientAPI {
    func request(parameters : [String : Any], type: String) -> Single<SendVerificationEmailResponse>
}
