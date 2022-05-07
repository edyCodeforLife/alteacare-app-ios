//
//  LoginAPI.swift
//  Altea Care
//
//  Created by Hedy on 07/03/21.
//

import Foundation
import RxSwift

protocol LoginAPI: ClientAPI {
    func request(parameters: [String: Any]) -> Single<LoginResponse>
}
