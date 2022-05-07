//
//  RegistrationChangeEmailAPI.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 23/04/21.
//

import Foundation
import RxSwift

//MARK: - Func api change email
protocol RegistrationChangeEmailAPI : ClientAPI {
    func request(body : [String : Any]) -> Single<RegistrationChangeEmailResponse>
}
