//
//  RegisterAPI.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 10/03/21.
//

import Foundation
import RxSwift

protocol RegisterAPI : ClientAPI {
    func request(body : [String: Any]) -> Single<RegisterResponse>
}
