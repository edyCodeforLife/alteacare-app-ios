//
//  ChangePasswordApi.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 30/04/21.
//

import Foundation
import RxSwift

protocol ChangePasswordApi : ClientAPI {
    func request(body:  ChangePasswordBody) -> Single<ChangePasswordResponse>
}
