//
//  TermRefundCancelAPI.swift
//  Altea Care
//
//  Created by Arif Rahman Sidik on 10/06/21.
//

import Foundation
import RxSwift

protocol TermRefundCancelAPI : ClientAPI {
    func request() -> Single<TermRefundCancelResponse>
}
