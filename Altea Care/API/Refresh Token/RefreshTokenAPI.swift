//
//  RefreshTokenAPI.swift
//  Altea Care
//
//  Created by Hedy on 23/03/21.
//

import Foundation
import RxSwift

protocol RefreshTokenAPI: ClientAPI {
    func request(parameters: [String: Any]) -> Single<RefreshTokenResponse>
}
