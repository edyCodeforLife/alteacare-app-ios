//
//  UserCancelAPI.swift
//  Altea Care
//
//  Created by Hedy on 29/12/21.
//

import Foundation
import RxSwift

protocol UserCancelAPI : ClientAPI {
    func requestCancel(body: [String: Any]) -> Single<UserCancelResponse>
}
