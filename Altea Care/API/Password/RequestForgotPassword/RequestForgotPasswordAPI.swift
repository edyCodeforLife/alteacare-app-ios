//
//  RequestForgotPasswordAPI.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 26/04/21.
//

import Foundation
import RxSwift

protocol RequestForgotPasswordAPI : ClientAPI {
    func request(body : RequestForgotPasswordBody) -> Single<RequestForgotPasswordResponse>
}
