//
//  AppTokenAPI.swift
//  Altea Care
//
//  Created by Hedy on 23/03/21.
//

import Foundation
import RxSwift

protocol AppTokenAPI: ClientAPI {
    func request(parameters: [String: Any]) -> Single<AppTokenResponse>
}
