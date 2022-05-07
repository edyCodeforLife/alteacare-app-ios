//
//  VerifyEmailAPI.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 23/04/21.
//

import Foundation
import RxSwift
import RxCocoa

//MARK: - API func verify email
protocol VerifyEmailAPI : ClientAPI {
    func request(body : [String : Any], type: String) -> Single<VerifyEmailResponse>
}
